//
//  AppController.m
//  AlphaFlameHD_Launcher
//
//  Created by Jared Bruni on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController


- (id) init {

	self = [super init];
	files = [[NSMutableArray alloc] init];	
	[tview setDataSource: self];
    [progress setHidden: YES];
	output_p = nil;
	return self;
	
}

- (void) dealloc {
	
	if(output_p != 0)
		[output_p release];
	
	[files release];
	[super dealloc];
	
}

- (IBAction) set_Enabled: (id) sender {
    
    if([chk_button1 integerValue] == 1) {
        [field1 setEnabled: YES];
        
    } else {
        [field1 setEnabled: NO];
    }
    
}


- (IBAction) addImage: (id) sender {

	NSOpenPanel *panel = [NSOpenPanel openPanel];
	NSArray *array = [NSArray arrayWithObjects:@"png", @"jpg", nil];
	[panel setAllowedFileTypes:array];
	[panel setAllowsMultipleSelection: YES];
	[panel runModal];
	NSArray *ar = [panel URLs];
	for(NSURL *str in ar) {
		if([files count] < 4) [files addObject: [str path]];
		
	}
	[tview reloadData];
	
}

- (IBAction) removeImage: (id) sender {
	int selRow = [tview selectedRow];
	if(selRow >= 0 && selRow < [files count]) {
		[files removeObjectAtIndex: selRow];
		[tview reloadData];
	}
}

- (IBAction) setPath: (id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection: NO];
	[panel setCanChooseFiles: NO];
	[panel setCanChooseDirectories: YES];
	if([panel runModal]) {
		NSArray *ar = [panel URLs];
		output_p = [[[ar objectAtIndex: 0] path ]retain];
		[output_path setStringValue: output_p];
	}
}

- (id) tableView:(id)tv objectValueForTableColumn: (NSTableColumn*)tableColumn row: (NSInteger) row {
	if(row >= 0 && row < [files count]) {
		
		NSString *type = [files objectAtIndex: row];
		
		if([[[tableColumn headerCell] stringValue] isEqualTo:@"Format" ]) return strstr([type UTF8String], "png") != 0 ? @"PNG" : @"JPEG"; else return [files objectAtIndex: row];
	}
	return @"";
}

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tv {
	return [files count];	
}


- (IBAction) runProgram: (id) sender {
	if(output_p == nil) {
		NSRunAlertPanel(@"Choose Output Directory", @"Select the output directory", nil, nil, nil);
		return;
	}
	
	if([files count] != 4) {
		NSRunAlertPanel(@"Choose Four PNG Graphics to use", @"Select four Graphics", nil, nil, nil);
		return;
	}
	
	NSInteger slow = [bt_slow integerValue];
	NSInteger full = [bt_scr integerValue];
	NSString *full_str;
	if(full) full_str = @"-f";
	else full_str = nil;
	NSString *slow_str;
	if(slow) slow_str = @"-s";
	else slow_str = nil;
	static NSInteger run_count = 0;
	++run_count;
	NSString *run_str = [NSString stringWithFormat:@"run%d", run_count];
	NSString *var_path = @"afhd";
	var_path = [[NSBundle mainBundle] pathForResource:@"afhd" ofType:nil];
	NSString *list_path = @"list.txt";
	list_path = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"txt"];
	FILE *fptr = fopen([list_path UTF8String], "w");
	for(NSString *s in files) {
		fprintf(fptr, "%s\n", [s UTF8String]);
	}
	fclose(fptr);
	NSString *final_string = [ NSString stringWithFormat: @"%@ %@ -p %@ %@ %@ -e %@", var_path, list_path, run_str, slow_str, full_str, output_p];
	NSMutableArray *ar = [[NSMutableArray alloc] init];
	[ar addObject:@"-i"];
	[ar addObject:list_path];
	[ar addObject:@"-p"];
	[ar addObject:run_str];
	[ar addObject:@"-e"];
	[ar addObject:output_p];
     
	if(full_str != nil) [ar addObject:full_str];
	if(slow_str != nil) [ar addObject:slow_str];
	if([run1080 integerValue]) [ar addObject:@"-m"];
    if([chk_button1 integerValue] == 1) {
        NSString *fps_s = [NSString stringWithFormat: @"%d", [field1 integerValue]];
        [ar addObject:@"-t"];
        [ar addObject: fps_s];        
        [ar addObject:@"-r"];
    }
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [progress setHidden: NO];
            [progress startAnimation:self];
        });
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           	NSTask *task = [[NSTask alloc] init];
            [task setArguments:ar];
            [task setLaunchPath:var_path];
            NSPipe *op = [[NSPipe alloc] init];
            [task setStandardOutput:op];
            [task launch];
            d = [[op fileHandleForReading] readDataToEndOfFile];
            [task waitUntilExit];
            status = [task terminationStatus];
            [op release];
            [task release];
            [ar release];
            
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *str = [[NSString alloc] initWithData:d encoding: NSUTF8StringEncoding];
            if(status != 0) {
                NSRunAlertPanel(@"Error occoured", str, @"Ok", nil, nil);
            } else {
                NSRunAlertPanel(@"Successful ", str, @"Ok", nil, nil);
            }		
 
            [progress setHidden: YES];
            [str release];
        });
        
    });
   
    
	NSLog(@"%@", final_string);
}

@end
