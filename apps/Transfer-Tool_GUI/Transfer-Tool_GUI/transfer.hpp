//
//  transfer.hpp
//  Transer-Tool
//
//  Created by Jared Bruni on 9/16/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#ifndef __TRANSFER_HPP
#define __TRANSFER_HPP

#include<string>
#include<mutex>

int program_main(int argc, std::string* argv);
extern std::mutex kb_mut;


#endif