//
//  CountLines.cpp
//  CountLines
//
//  Created by Jared Bruni on 9/27/18.
//  Copyright © 2018 Jared Bruni. All rights reserved.
//

#include "CountLines.hpp"

std::ostringstream output;
const char *file_ext[] = { ".cpp", ".h", ".hpp",".c",".cc", ".cxx",".m", ".mm", 0 };

std::string procLines(std::string path) {
    output.str("");
    std::vector<std::string> files;
    add_directory(path, files);
    unsigned long count = 0;
    if(files.size() > 0) {
        unsigned long blank = 0;
        count = countLines(files, blank);
        output << files.size() << " file(s) contain: " << count << " lines and " << blank << "  blank lines for a total of " << blank+count << ".\n";
        return output.str();
    }
    return " Could not find any files...";
}

bool lineEmpty(const std::string &line) {
    for(unsigned int i = 0; i < line.length(); ++i) {
        if(line[i] != ' ' && line[i] != '\t' && line[i] != '\n' && line[i] != '\r')
            return false;
    }
    return true;
}

unsigned long countFile(std::string filename, unsigned long &blank) {
    unsigned long counter = 0;
    std::fstream file;
    file.open(filename, std::ios::in);
    if(!file.is_open()) {
        output << "Could not open file: " << filename << "\n";
        return 0;
    }
    while(!file.eof()) {
        std::string line;
        std::getline(file, line);
        if(file && lineEmpty(line) == false) {
            ++counter;
        } else {
            ++blank;
        }
    }
    file.close();
    return counter;
}

unsigned long countLines(std::vector<std::string> &v, unsigned long &blank) {
    unsigned long value = 0;
    for(unsigned int i = 0; i < v.size(); ++i) {
        unsigned long blank_lines = 0;
        unsigned long line_count = countFile(v[i], blank_lines);
        blank += blank_lines;
        if(line_count > 0) {
            output << v[i] << ": " << line_count << " lines " << blank_lines << " blank lines for total of " << (line_count+blank_lines) << "\n";
            value += line_count;
        }
    }
    return value;
}

void add_directory(std::string path, std::vector<std::string> &files) {
    DIR *dir = opendir(path.c_str());
    if(dir == NULL) {
        output << "Error could not open directory: " << path << "\n";
        return;
    }
    dirent *file_info;
    while( (file_info = readdir(dir)) != 0 ) {
        std::string f_info = file_info->d_name;
        if(f_info == "." || f_info == "..")  continue;
        std::string fullpath=path+"/"+f_info;
        struct stat s;
        
        lstat(fullpath.c_str(), &s);
        if(S_ISDIR(s.st_mode)) {
            if(f_info.length()>0 && f_info[0] != '.')
                add_directory(path+"/"+f_info, files);
            continue;
        }
        if(f_info.length()>0 && f_info[0] != '.') {
            bool found = false;
            std::string ext_str = toLower(fullpath);
            auto pos = ext_str.rfind(".");
            if(pos == std::string::npos) continue;
            
            std::string ext = ext_str.substr(pos, ext_str.length()-pos);
            for(int i = 0; file_ext[i] != 0; ++i) {
                if(ext == file_ext[i]) {
                    found = true;
                    break;
                }
            }
            if(found == true) {
                files.push_back(fullpath);
                output << "Source File Found: " << fullpath << "\n";
            }
        }
    }
    closedir(dir);
}

std::string toLower(const std::string &s) {
    std::string temp;
    for(unsigned int i = 0; i < s.length(); ++i)
        temp += tolower(s[i]);
    return temp;
}
