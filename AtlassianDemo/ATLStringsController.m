//
//  ATLStringsController.m
//  AtlassianDemo
//
//  Created by John Wells on 2/4/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import "ATLStringsController.h"

NSString *const StringsControllerDidAddStringNotification = @"StringsControllerDidAddStringNotification";

@interface ATLStringsController()

@property (strong, nonatomic) NSMutableArray *strings;
@property (strong, nonatomic) NSOperationQueue *generationQueue;

@end

@implementation ATLStringsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _strings = [NSMutableArray array];
        _generationQueue = [NSOperationQueue new];
        _generationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)addJSONFromString:(NSString *)string
{
    JSONGeneratorOperation *generator = [[JSONGeneratorOperation alloc] init];
    
    generator.originalString = string;
    generator.delegate = self;
    
    [self.generationQueue addOperation:generator];
}

-(void)generatorDidFinishCreatingJSONString:(NSString *)json
{
    [self.strings addObject:json];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:StringsControllerDidAddStringNotification
                                                        object:json];
}

-(NSArray *)JSONStrings
{
    return [NSArray arrayWithArray:self.strings];
}

@end