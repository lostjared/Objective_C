//
//  AppController.h
//  m3u_gen
//
//  Created by Jared Bruni on 9/26/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#include<vector>
#include<string>
#include<random>

@interface AppController : NSObject <NSTableViewDataSource>{
    NSMutableArray *table_items;
    IBOutlet NSTableView *table;
    IBOutlet NSButton *check_box, *add_dir, *outputf, *sorted_box;
    IBOutlet NSMatrix *matrix;
    IBOutlet NSComboBox *box;
    
    
    NSString *dirp;
}


- (IBAction) addToList: (id) sender;
- (IBAction) saveM3u: (id) sender;
- (IBAction) sortList: (id) sender;
- (void) rebuildArray: (std::vector<std::string>) files;
- (IBAction) resetList: (id) sender;
- (IBAction) addFileType: (id) sender;
@end
