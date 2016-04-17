/*
 
 C++11 example simple tcp/ip networking with sockets.
 
 to send a file:
 
 transfer-tool ipaddress port filename
 
 to serve up files:
 
 transfer-tool port
 
 if your behind a router, be sure to forward that port 
 
 will serve up files in the local directory where the program is ran
 
 written by Jared Bruni
 vist me online @ http://facebook.com/LostSideDead0x
 
  http://lostsidedead.com
 
*/


#include<iostream>
#include<thread>
#include<vector>
#include<fstream>
#include<sstream>
#include"socket.hpp"
#import"AppController.h"
#include"transfer.hpp"


// listen_at thread function
void listen_at(std::string user_ip, std::string filepath1, int sock_id, std::string password) {
    try {
        mx::mxSocket sock{sock_id};
        std::mutex mut;
        int pw_value = 0;
        int value = 0;
        sock.Read(&pw_value, sizeof(pw_value));
        char *pass = new char [pw_value+1];
        sock.Read(pass, pw_value);
        pass[pw_value] = 0;
        std::string pw=pass;
        delete [] pass;
        char c = 0;
        if(pw == password)
            c = 1;
        else
            c = 0;
        
        sock.Write(&c, sizeof(c));
        if(c == 0) {
            dispatch_sync(dispatch_get_main_queue(), ^() {
                ListenOutput("Error invalid password.");
                
            });
            sock.closeSocket();
            return;
        }
    
        sock.Read(&value, sizeof(value));
        if(value>0) {
            char *buffer = new char[value+1];
            sock.Read(buffer, value);
            buffer[value] = 0;
            mut.lock();
            std::string file_path=buffer;
            delete [] buffer;
            mut.unlock();
            if(file_path.find("\\") != -1) {
                mut.lock();
                std::ostringstream s;
                s << "User: " << user_ip << " Sent illegal filename..";
                const char *sz = s.str().c_str();
                dispatch_sync(dispatch_get_main_queue(), ^{
                    ListenOutput(sz);
                });
                mut.unlock();
            }
            auto pos = file_path.rfind("/");
            std::string filename=file_path.substr(pos+1,file_path.length()-pos);
            mut.lock();
            std::ostringstream ss;
            ss << "Sending... " << filename;
            const char *temp = ss.str().c_str();
            dispatch_sync(dispatch_get_main_queue(), ^{
                ListenOutput(temp);
            });
            mut.unlock();
            std::string src_file=filepath1+"/"+filename;
            std::fstream fs;
            fs.open(src_file, std::ios::in | std::ios::binary);
            char fn = 0;
            if(!fs.is_open()) {
                mut.lock();
                dispatch_sync(dispatch_get_main_queue(), ^{
                    ListenOutput("Asked for file not in directory");
                });
                mut.unlock();
                fn = 0;
                sock.Write(&fn, sizeof(fn));
                sock.closeSocket();
                return;
            } else {
                fn = 1;
                sock.Write(&fn, sizeof(fn));
            }
            fs.seekg(0, std::ios::end);
            unsigned long len = fs.tellg();
            fs.seekg(0, std::ios::beg);
            mut.unlock();
            sock.Write(&len, sizeof(len));
            while(!fs.eof()) {
                mut.lock();
                if(stop_server == true) {
                    mut.unlock();
                    return;
                }
                mut.unlock();
                char buff[256];
                fs.read(buff, 256);
                auto bytes_read=fs.gcount();
                if(bytes_read<=0) break;
                sock.Write(buff, bytes_read);
            }
            fs.close();
            sock.closeSocket();
            mut.lock();
            dispatch_sync(dispatch_get_main_queue(), ^{
                ListenOutput("File sent..");
            });
            mut.unlock();
            return;
        }
    }
    catch(mx::ReadWriteError) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            ListenOutput("Error on read/write.");
        });
    }
}


unsigned long sent_bytes = 0;
unsigned long total=0;

// read file to this program on ip, port and filename
void read_file(std::string ip, int port, std::string file_path, std::string dir_path, std::string password) {
    mx::mxSocket sock;
    sock.createSocket();
    total = 0;
    if(sock.connectTo(ip, port)) {
        
        int pw_value=(int)password.length();
        sock.Write(&pw_value, sizeof(pw_value));
        sock.Write(const_cast<char*>(password.c_str()), pw_value);
        char tf = 1;
        sock.Read(&tf, sizeof(tf));
        if(tf == 0) {
            sock.closeSocket();
            dispatch_sync(dispatch_get_main_queue(), ^(){
                NSRunAlertPanel(@"Invalid Password",@"Error", @"Ok", nil, nil, nil);
            });
            return;
        }
        int value=(int)file_path.length();
        sock.Write(&value, sizeof(value));
        sock.Write(const_cast<char*>(file_path.c_str()), value);
        
        char rt_value = 0;
        sock.Read(&rt_value, sizeof(rt_value));
        if(rt_value == 0) {
            sock.closeSocket();
            dispatch_sync(dispatch_get_main_queue(), ^() {
                NSRunAlertPanel(@"File not found on server.", @"Not found.", @"Ok", nil, nil, nil);
            });
            return;
        }
        
        std::fstream fs;
        auto p=file_path.rfind("/");
        std::string local_name=dir_path+"/"+file_path.substr(p+1, file_path.length());
        
        
        dispatch_sync(dispatch_get_main_queue(), ^() {
            [controller show_transfer:nil];
            [[controller transfer_win] setTitle:@"Transfering"];
            [[controller transfer_close] setEnabled: NO];
            NSString *temp_str = [[NSString alloc] initWithUTF8String:local_name.c_str()];
            [[controller transfer_filename] setStringValue:temp_str ];
            [temp_str release];
        });
        
        fs.open(local_name, std::ios::binary | std::ios::out);
        unsigned long file_size=0;
        sock.Read(&file_size, sizeof(file_size));
        if(!fs.is_open()) {
            std::cout << "Error could not open file for writing.\n";
            sock.closeSocket();
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^() {
            [[controller progress_bar] setMinValue: 0];
            [[controller progress_bar] setMaxValue: file_size];
            [[controller progress_bar] startAnimation: controller];
            
        });
        ssize_t rd_bytes=0;
        int packet_size = 1024*10;
        char buffer[1024*10];
        while((rd_bytes = sock.Read((char*)buffer,packet_size)) != 0) {
            fs.write(buffer, rd_bytes);
            total += rd_bytes;
            sent_bytes += rd_bytes;
            dispatch_sync(dispatch_get_main_queue(), ^() {
                [[controller progress_bar] setDoubleValue: total];
                [[controller progress_bar] displayIfNeeded];
                unsigned long total_bytes=sent_bytes/1024;
                kbsent += total_bytes;
                [controller setCurKb: kbsent];
                sent_bytes = 0;
            });
        }
        fs.close();
        sock.closeSocket();
        dispatch_sync(dispatch_get_main_queue(), ^() {
            [[controller progress_bar] setDoubleValue:total];
            [[controller progress_bar] stopAnimation:controller];
            [[controller transfer_show] setEnabled :YES];
            [[controller connect_button] setEnabled: YES];
            [[controller transfer_win] setTitle:@"Transfered"];
            [[controller transfer_close] setEnabled: YES];
            [[controller update_timer] invalidate];
            NSString *t = [[NSString alloc] initWithFormat: @"Transferred %lu kb", (total/1024)];
            [[controller transfered_kb] setStringValue: t];
            [t release];
        });
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^() {
            std::ostringstream err_text;
            err_text << "Could not connect to: " << ip << ":" << port;
            NSString *text = [[NSString alloc] initWithUTF8String: err_text.str().c_str()];
            NSRunAlertPanel(text, @"Error", @"Ok", nil, nil, nil);
            [text release];
        });
    }
}

//extern "C" int program_main(int argc, const char **argv) {
int program_main(int argc, std::string argv[4]) {
    
    try {
        std::vector<std::thread> thread_array;
        if(argc == 4) {
            unsigned int port = atoi(argv[1].c_str());
            std::string pass=argv[3];
            bool active = true;
            std::string fpath = argv[2];
            mx::mxSocket sock;
            sock.createSocket();
            while(active == true) {
                if(sock.listenAt(port)) {
                    std::string user_ip;
                    int sockid = sock.acceptNewSocket(user_ip);
                    dispatch_sync(dispatch_get_main_queue(), ^() {
                        std::ostringstream stream;
                        stream << "Connected to: " << user_ip;
                        ListenOutput(stream.str().c_str());
                    });
                    thread_array.emplace_back(listen_at, user_ip, fpath, sockid, pass);
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^() {
                        NSRunAlertPanel(@"Error on listen.\n", @"Listen Error", @"Ok", nil ,nil, nil);
                    });
                    return 0;
                }
            }
        } else if(argc == 6) {
            try {
                std::string ip = argv[1];
                unsigned int port = atoi(argv[2].c_str());
                std::string file_path=argv[3];
                read_file(ip, port, file_path, argv[4], argv[5]);
            }
            catch(mx::ReadWriteError) {
                std::cerr << "Error on read or write.\n";
                dispatch_sync(dispatch_get_main_queue(), ^() {
                    NSRunAlertPanel(@"Read error Connection reset? ", @"There was a error.", @"Ok", nil, nil, nil);
                });
            }
        }
    }
    catch(std::exception &e) {
        std::cerr << e.what() << "\n";
    }
    catch(...) {
        std::cerr << "Unkwown Error ..\n";
    }
    return 0;
}