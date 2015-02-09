//
//  ATLStringsController.h
//  AtlassianDemo
//
//  Created by John Wells on 2/4/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "JSONGeneratorOperation.h"

extern NSString *const StringsControllerDidAddStringNotification;

@interface ATLStringsController : NSObject <JSONGeneratorDelegate>

@property (readonly) NSArray *JSONStrings;

- (void)addJSONFromString:(NSString *)string;

@end