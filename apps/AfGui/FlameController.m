//
//  FlameController.m
//  AfGui
//
//  Created by Jared Bruni on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlameController.h"


@implementation FlameController


- (id) init {
	[super init];
	file_v = [[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc {
	[file_v release];
	[super dealloc];
}


- (IBAction) addFiles: (id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	NSArray *array = [NSArray arrayWithObject:@"png"];
	[panel setAllowedFileTypes:array];
	[panel setAllowsMultipleSelection: YES];
	[panel runModal];
	NSArray *ar = [panel URLs];
	for(NSURL *str in ar) {
		if([file_v count] < 4) [file_v addObject: [str path]];
	}
	[vi reloadData];
}

- (IBAction) rmvFile: (id) sender {
	int selRow = [vi selectedRow];
	if(selRow >= 0 && selRow < [file_v count]) {
		[file_v removeObjectAtIndex: selRow];
		[vi reloadData];
	}
}

- (id) tableView:(NSTableView *)tv objectValueForTableColumn: (NSTableColumn*)tableColumn row: (int) row {
	if(row >= 0 && row < [file_v count]) {
		return [file_v objectAtIndex: row];
	}
	return @"";
}

- (int) numberOfRowsInTableView: (NSTableView *)tv {
	return [file_v count];
}

- (void) tableViewSelectionDidChange: (NSNotification*)aNotification {
	int currentSel = [vi selectedRow];
	if(currentSel >= 0 && currentSel < [file_v count]) {
		NSImage *img = [[NSImage alloc] initWithContentsOfFile: [file_v objectAtIndex: currentSel]];
		[v setImage: img];
		[img release];
	}
}

- (IBAction) slidePos: (id) sender {
	float pos = [slide integerValue];
	[label setIntegerValue:pos];
}

- (IBAction) runFilter: (id) sender {
	
	if([file_v count] < 4) {
		NSRunAlertPanel(@"Missing Graphics", @"Requires four PNG Graphics", @"Ok", nil, nil);
		return;
	}
	
	NSSavePanel *panel = [NSSavePanel savePanel];
	NSArray *ar = [NSArray arrayWithObject:@"png"];
	[panel setAllowedFileTypes:ar];
	[panel runModal];
	NSString *out_path = [[panel URL] path];	
	if(out_path == nil) return;
	int iter = [slide integerValue];
	int before = [chk integerValue];
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *aft = [bundle pathForResource:@"aftool" ofType:nil];
	NSString *image_path = [bundle bundlePath];
	NSString *in_file = [NSString stringWithFormat:@"%@%@", image_path, @"/Contents/Resources/list.txt"];
	/* using C api instead of Cocoa cause its easier */
	FILE *fptr = fopen([in_file UTF8String], "w");
	for(int i = 0; i < [file_v count]; i++) {
		fprintf(fptr, "%s\n", [[file_v objectAtIndex: i] UTF8String]);
	}
	fclose(fptr);
	/* end */
	NSString *bef;
	if(before) bef = @"-m"; else bef = @"-a";
	NSString *iterations = [NSString stringWithFormat:@"%d", iter];
	NSTask *task = [[NSTask alloc] init];
	NSArray *args = [NSArray arrayWithObjects:in_file, iterations, out_path, bef, nil];
	[task setLaunchPath:aft];
	[task setArguments:args];
	NSPipe *op = [[NSPipe alloc] init];
	[task setStandardOutput:op];
	[task launch];
	NSData *d = [[op fileHandleForReading] readDataToEndOfFile];
	[task waitUntilExit];
	int status = [task terminationStatus];
	[op release];
	[task release];
	NSString *str = [[NSString alloc] initWithData:d encoding: NSUTF8StringEncoding];
	if(status != 0) {
		NSRunAlertPanel(@"Error occoured", str, @"Ok", nil, nil);
	} else {
		NSRunAlertPanel(@"Successful ", str, @"Ok", nil, nil);
		// show sheet with image
		[fin_obj setImagePath: out_path];
		NSImage *img = [[NSImage alloc] initWithContentsOfFile: out_path];
		[[fin_obj viewObject] setImage: img];
		[img release];
		//[[fin_obj viewObject] setImage: [[NSImage alloc] initWithContentsOfFile: out_path]];
		[NSApp beginSheet: fin modalForWindow: [v window] modalDelegate:nil didEndSelector:NULL contextInfo: NULL];
		
	}
	[str release];
	
}

@end
