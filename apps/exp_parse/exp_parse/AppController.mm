//
//  AppController.m
//  exp_parse
//
//  Created by Jared Bruni on 9/15/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import "AppController.h"
#import "lexer.hpp"
#include<unordered_map>
#include<sstream>
#include<iomanip>

std::unordered_map<std::string, double> variables;
std::unordered_map<std::string, lex::Func> functions;

double val_sqrt(double d) { return sqrtf(d); }
double val_abs(double d) { return abs(d); }
double val_print(double d) {
    std::ostringstream stream;
    stream << "Print Message: " << d << "\n";
    NSString *str = [NSString stringWithUTF8String: stream.str().c_str()];
    NSRunAlertPanel(@"Print function", str, @"Ok", nil, nil, nil);
    return d;
}
double val_cosf(double d) { return cosf(d); }
double val_sinf(double d) { return sinf(d); }
double val_log(double d) { return logf(d); }
double val_tan(double d) { return tanf(d); }
double val_rand(double d) { return std::rand()%static_cast<int>(d); }
double val_exit(double d) {
    throw lex::Exit_Exception();
    return 0;
}
double val_acos(double d) { return acos(d); }
double val_asin(double d) { return asin(d); }
double val_atan(double d) { return atan(d); }
double val_floor(double d) { return floor(d); }

void add_func(std::initializer_list<lex::Func> lst) {
    for(auto &i : lst) {
        functions[i.name] = i;
    }
}

void initalize_functions() {
    std::srand(static_cast<unsigned int>(std::time(0)));
    add_func({
        {"sqrt",val_sqrt}, {"abs",val_abs},
        {"print",val_print}, {"cos",val_cosf},
        {"sin",val_sinf}, {"tan",val_tan},
        {"log",val_log}, {"acos", val_acos},
        {"asin", val_asin}, {"atan", val_atan},
        {"floor", val_floor},
        {"rand",val_rand}
    });

}

@implementation ListItems

@synthesize variable_value;
@synthesize variable_name;

@end

@implementation AppController

- (id) init {
    self = [super init];
    listItems = [[NSMutableArray alloc] init];
    initalize_functions();
    [table_view setDataSource: self];
    return self;
}

- (void) dealloc {
    [super dealloc];
    [listItems release];
}

- (IBAction) parseExpression: (id) sender {
    NSString *text = [[actual_text textStorage] string];
    if([text length] <= 0) return;
    try {
        [self grabInput:nil];

        [listItems release];
        listItems = [[NSMutableArray alloc] init];
        
        for(std::unordered_map<std::string, double>::iterator vi = variables.begin(); vi != variables.end(); ++vi) {
            ListItems *addItem = [[ListItems alloc] init];
            const char *var_name = vi->first.c_str();
            double var_val =  vi->second;
            addItem.variable_name = [NSString stringWithUTF8String: var_name];
            addItem.variable_value = [NSString stringWithFormat: @"%f", var_val];
            [addItem autorelease];
            [listItems addObject: addItem];
        }
        
        [table_view reloadData];
    }
    catch(lex::Scanner_EOF) {
        
    }
    catch(lex::Scanner_Error &e) {
        NSString *text = [NSString stringWithUTF8String: e.error_text.c_str()];
        NSRunAlertPanel(text, @"Error has occoured.\n", @"Ok", nil, nil, nil);
    }
    catch(lex::Exit_Exception) {
        
    }

}

- (void) grabInput: (id) sender {
    std::string s;
    NSString *value = [[actual_text textStorage] string];

    s = std::string([value UTF8String]);
    
    
    if(s.find(";")  == -1) {
        std::cerr << "Error missing semi-colon\n";
        NSRunAlertPanel(@"Error Expression missing semi-colon.", @"To fix add a semi-colon", @"Ok", nil, nil, nil);
       // return grabInput();
        return;
    }
    if(s.length()==0) return;
    
    std::istringstream stream(s);
    lex::Parser pscan(stream, variables, functions);
    if(pscan.eval()) {
        for (auto &s : variables) {
            std::cout << std::setw(10) << s.first << " " << std::setw(10) << s.second << "\n";
        }
    }
}

- (IBAction) clearTableView: (id) sender {
    
    variables.erase(variables.begin(), variables.end());
    
    [listItems removeAllObjects];
    [table_view reloadData];
}


- (IBAction) clearText: (id) sender {
    [actual_text setString: @""];
}

- (id) tableView:(id)tv objectValueForTableColumn: (NSTableColumn*)tableColumn row: (NSInteger) row {
    if(row >= 0 && row < [listItems count]) {
        NSString *str = [[listItems objectAtIndex:row] variable_value];
        NSString *val = [[listItems objectAtIndex:row] variable_name];
        if([[[tableColumn headerCell] stringValue] isEqualTo:@"Variable"]) return val;  else return str;
    }
    return @"";
}

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tv {
    return [listItems count];
}

@end
