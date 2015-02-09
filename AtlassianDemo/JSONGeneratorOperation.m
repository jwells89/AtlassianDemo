//
//  JSONGeneratorOperation.m
//  AtlassianDemo
//
//  Created by John Wells on 2/5/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import "JSONGeneratorOperation.h"

@interface JSONGeneratorOperation ()

@property (strong, nonatomic) NSMutableArray *mentions;
@property (strong, nonatomic) NSMutableArray *emoticons;
@property (strong, nonatomic) NSMutableArray *links;

@property (strong, nonatomic) NSString *jsonString;

@end

@implementation JSONGeneratorOperation

-(void)main
{
    self.mentions = [NSMutableArray array];
    self.emoticons = [NSMutableArray array];
    self.links = [NSMutableArray array];
    
    [self findContent];
    [self fetchURLTitles];
    [self generateJSON];
    
    __weak JSONGeneratorOperation *weakSelf = self;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf.delegate generatorDidFinishCreatingJSONString:weakSelf.jsonString];
    });
}

- (void)findContent
{
    NSRegularExpression *mentionsRegex = [NSRegularExpression regexWithPattern:@"\\B(@\\w+)"];
    NSRegularExpression *emoticonsRegex = [NSRegularExpression regexWithPattern:@"\\(\\w+\\)"];
    NSRegularExpression *URLsRegex = [NSRegularExpression regexWithPattern:@"(https?://\\w+\\.*\\S*)"];
    
    NSArray *mentionMatches = [mentionsRegex matchesInFullString:self.originalString];
    NSArray *emoticonMatches = [emoticonsRegex matchesInFullString:self.originalString];
    NSArray *URLMatches = [URLsRegex matchesInFullString:self.originalString];

    for (NSTextCheckingResult *match in mentionMatches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [self.originalString substringWithRange:matchRange];
        
        [self.mentions addObject:matchString];
    }
    
    for (NSTextCheckingResult *match in emoticonMatches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [self.originalString substringWithRange:matchRange];
        
        [self.emoticons addObject:matchString];
    }
    
    for (NSTextCheckingResult *match in URLMatches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [self.originalString substringWithRange:matchRange];
        
        NSMutableDictionary *link = [@{@"url" : matchString} mutableCopy];
        [self.links addObject:link];
    }
}

- (void)fetchURLTitles
{
    for (NSMutableDictionary *d in self.links) {
        NSError *error = nil;
        NSURL *URL = [NSURL URLWithString:d[@"url"]];
        NSURLRequest *siteRequest = [[NSURLRequest alloc] initWithURL:URL cachePolicy:0 timeoutInterval:2.0];
        NSURLResponse *response = nil;
        NSData *siteData = [NSURLConnection sendSynchronousRequest:siteRequest
                                                 returningResponse:&response
                                                             error:&error];
        NSString *htmlString = [[NSString alloc] initWithData:siteData encoding:NSUTF8StringEncoding];
        
        if (!htmlString || error) {
            d[@"title"] = d[@"url"];
            continue;
        }
        
        NSScanner *titleScanner = [NSScanner scannerWithString:htmlString];
        NSCharacterSet *titleTag = [NSCharacterSet characterSetWithCharactersInString:@"<title>"];
        NSString *title = nil;
        
        [titleScanner scanUpToString:@"<title>" intoString:nil];
        if (![titleScanner isAtEnd]) {
            [titleScanner scanCharactersFromSet:titleTag intoString:nil];
            [titleScanner scanUpToString:@"</title>" intoString:&title];
        }
        
        d[@"title"] = title ? title : d[@"url"];
    }
}

- (void)generateJSON
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    
    if (self.mentions) {
        [content setObject:self.mentions forKey:@"mentions"];
    }
    
    if (self.emoticons) {
        [content setObject:self.emoticons forKey:@"emoticons"];
    }
    
    if (self.links) {
        [content setObject:self.links forKey:@"links"];
    }

    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:content
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    self.jsonString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

@end

@implementation NSRegularExpression (JWSShorthand)

+ (NSRegularExpression *)regexWithPattern:(NSString *)pattern
{
    return [NSRegularExpression regularExpressionWithPattern:pattern
                                                     options:0
                                                       error:NULL];
}

- (NSArray *)matchesInFullString:(NSString *)string
{
    NSRange originalStringRange = NSMakeRange(0, [string length]);
    return [self matchesInString:string options:0 range:originalStringRange];
}

@end
