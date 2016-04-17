//
//  AppController.h
//  exp_parse
//
//  Created by Jared Bruni on 9/15/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListItems : NSObject {
    
    NSString *variable_name;
    NSString *variable_value;
}

@property (retain) NSString *variable_name;
@property (retain) NSString *variable_value;

@end

@interface AppController : NSObject<NSTableViewDataSource>
{
    
    IBOutlet NSScrollView *text_view;
    IBOutlet NSTextView   *actual_text;
    IBOutlet NSTableView  *table_view;
    NSMutableArray *listItems;
}

- (IBAction) parseExpression: (id) sender;
- (IBAction) clearTableView: (id) sender;
- (IBAction) clearText: (id) sender;
- (void) grabInput: (id) sender;

@end
