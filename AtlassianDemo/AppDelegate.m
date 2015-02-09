//
//  AppDelegate.m
//  AtlassianDemo
//
//  Created by John Wells on 2/4/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import "AppDelegate.h"
#import "ATLStringsController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) ATLStringsController *stringsController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.stringsController = [[ATLStringsController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStringsPopup:)
                                                 name:StringsControllerDidAddStringNotification
                                               object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)createJSONFromField:(id)sender {
    [[self.titleFetchView animator] setAlphaValue:1.0];
    [self.titleFetchSpinner startAnimation:nil];
    [self.stringsController addJSONFromString:self.messageField.stringValue];
    self.messageField.stringValue = @"";
}

- (void)updateStringsPopup:(NSNotification *)notification
{
    [self.titleFetchSpinner stopAnimation:nil];
    [[self.titleFetchView animator] setAlphaValue:0.0f];
    [self.stringsPopup removeAllItems];
    
    NSArray *strings = self.stringsController.JSONStrings;
    NSInteger counter;
    
    for (counter = 0; counter < [strings count]; counter++) {
        NSMenuItem *item = [[NSMenuItem alloc] init];
        NSString *title = [NSString stringWithFormat:@"String #%ld", counter+1];
        
        [item setTitle:title];
        [item setTarget:self];
        [item setAction:@selector(showSelectedString)];
        [self.stringsPopup.menu addItem:item];
    }
    
    [self.stringsPopup selectItem: [self.stringsPopup lastItem]];
    [self showSelectedString];
}

- (void)showSelectedString
{
    NSInteger selectedStringIndex = [self.stringsPopup.menu indexOfItem:[self.stringsPopup selectedItem]];
    NSString *selectedString = self.stringsController.JSONStrings[selectedStringIndex];
    [self.jsonTextView setString:selectedString];
}

@end
