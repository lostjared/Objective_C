//
//  AppController.m
//  m3u_gen
//
//  Created by Jared Bruni on 9/26/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import "AppController.h"
#import "m3u.hpp"



@implementation AppController

std::vector<std::string> file_types;

- (id) init {
    self = [super init];
    table_items = [[NSMutableArray alloc] init];
    file_types.push_back("mp3");
    file_types.push_back("mp4");
    file_types.push_back("wav");
    file_types.push_back("ogg");
    file_types.push_back("flac");
    file_types.push_back("m4a");
    return self;
}

- (void) awakeFromNib {
    NSArray *arr = [NSArray arrayWithObjects: @"mp3", @"mp4", @"wav", @"ogg", @"flac", @"m4a", nil];
    [box addItemsWithObjectValues: arr];
    [box reloadData];
}

- (IBAction) addToList: (id) sender {
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    if([panel runModal]) {
        NSString *dir_path = [[[panel URLs] objectAtIndex: 0] path];
        std::vector<std::string> file_list;
        m3u::add_directory([dir_path UTF8String], file_list);
        m3u::remove_path([dir_path UTF8String], file_list);
        [self rebuildArray: file_list];
        [table reloadData];
        [add_dir setEnabled: NO];
        dirp = [NSString stringWithString:dir_path];
        [outputf setEnabled: YES];
        [matrix setEnabled: NO];
    }
    
}

- (void) rebuildArray: (std::vector<std::string>) files {
    
    NSCell *button = [matrix cellAtRow: 0 column: 0];
  
    if([button integerValue] == 0) {
        std::sort(files.begin(), files.end());
        std::default_random_engine dre(static_cast<int>(std::time(0)));
        std::shuffle(files.begin(), files.end(), dre);
        // shuffle
    } else {
        std::sort(files.begin(), files.end());
    }
    
    
    
    
    
    for(unsigned int i = 0; i != files.size(); ++i) {
        NSString *str = [NSString stringWithUTF8String: files[i].c_str()];
        if(m3u::isFileType(files[i], file_types) == true)
            [table_items addObject: str];
    }
    
}

- (IBAction) resetList: (id) sender {
    [add_dir setEnabled: YES];
    [table_items removeAllObjects];
    [table reloadData];
    [outputf setEnabled: NO];
    [matrix setEnabled: YES];
}

- (IBAction) saveM3u: (id) sender {
    
    NSString *path = [NSString stringWithFormat: @"%@/output.m3u", dirp];
    std::fstream file;
    file.open([path UTF8String], std::ios::out);
    if(!file.is_open()) {
        NSRunAlertPanel(@"Could not open file", path, @"Ok", nil ,nil ,nil);
        return;
    }
    for(unsigned int i = 0; i < [table_items count]; ++i) {
        std::string temp = [[table_items objectAtIndex:i] UTF8String];
        file << temp << "\n";
    }
    file.close();
    NSRunAlertPanel(@"Wrote m3u file at", path, @"Ok", nil, nil, nil);
    
}
- (IBAction) sortList: (id) sender {
    
}

- (IBAction) addFileType: (id) sender {
    NSString *str = [box stringValue];
    if([str length] > 0) {
        file_types.push_back([str UTF8String]);
        [box addItemWithObjectValue:str];
        [box setStringValue: @""];
    }
}


- (id) tableView:(id)tv objectValueForTableColumn: (NSTableColumn*)tableColumn row: (NSInteger) row {
    
    if(row >= 0 && row < [table_items count]) {
        NSString *val = [NSString stringWithFormat: @"%d", (int)row];
        NSString *str = [table_items objectAtIndex: row];
        if([[[tableColumn headerCell] stringValue] isEqualTo:@"Index"]) return val;  else return str;
    }
    return @"";
}

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tv {
    return [table_items count];
}

@end
