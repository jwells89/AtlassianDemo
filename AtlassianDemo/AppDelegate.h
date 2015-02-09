//
//  AppDelegate.h
//  AtlassianDemo
//
//  Created by John Wells on 2/4/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *messageField;
@property (weak) IBOutlet NSPopUpButton *stringsPopup;
@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (weak) IBOutlet NSView *titleFetchView;
@property (weak) IBOutlet NSProgressIndicator *titleFetchSpinner;

@end

