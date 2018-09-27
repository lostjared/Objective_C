//
//  CountLines.hpp
//  CountLines
//
//  Created by Jared Bruni on 9/27/18.
//  Copyright © 2018 Jared Bruni. All rights reserved.
//

#ifndef CountLines_hpp
#define CountLines_hpp

#include<iostream>
#include<fstream>
#include<iomanip>
#include<string>
#include<vector>
#include<unistd.h>
#include<dirent.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<algorithm>
#include<cctype>
#include<regex>
#include<sstream>

std::string procLines(std::string path);
void add_directory(std::string path, std::vector<std::string> &files);
std::string toLower(const std::string &s);
extern const char *file_ext[];
unsigned long countLines(std::vector<std::string> &v, unsigned long &blank);
unsigned long countFile(std::string filename, unsigned long &blank);
bool lineEmpty(const std::string &line);
extern std::ostringstream output;

#endif /* CountLines_hpp */
