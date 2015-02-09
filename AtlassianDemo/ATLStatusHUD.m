//
//  ATLStatusHUD.m
//  AtlassianDemo
//
//  Created by John Wells on 2/8/15.
//  Copyright (c) 2015 John Wells. All rights reserved.
//

#import "ATLStatusHUD.h"

@interface ATLStatusHUD ()

@property (strong, nonatomic) NSColor *fillColor;
@property (strong, nonatomic) NSBezierPath *bezelBezier;

@end

@implementation ATLStatusHUD

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.fillColor set];
    [self.bezelBezier fill];
}

-(NSColor *)fillColor
{
    if (_fillColor) {
        return _fillColor;
    }
    
    _fillColor = [NSColor colorWithWhite:0 alpha:.15];
    return _fillColor;
}

-(NSBezierPath *)bezelBezier
{
    if (_bezelBezier) {
        return _bezelBezier;
    }
    
    _bezelBezier = [NSBezierPath bezierPathWithRoundedRect:[self bounds]
                                                   xRadius:4.0f yRadius:4.0f];
    return _bezelBezier;
}

@end
