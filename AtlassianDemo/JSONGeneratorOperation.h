//
//  JSONGeneratorOperation.h
//  AtlassianDemo
//
//  Created by John Wells on 2/5/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONGeneratorDelegate <NSObject>

- (void)generatorDidFinishCreatingJSONString:(NSString *)json;

@end

@interface JSONGeneratorOperation : NSOperation

@property (weak, nonatomic) id<JSONGeneratorDelegate> delegate;
@property (strong, nonatomic) NSString *originalString;

@end

@interface NSRegularExpression (JWSShorthand)

+ (NSRegularExpression *)regexWithPattern:(NSString *)pattern;
- (NSArray *)matchesInFullString:(NSString *)string;

@end