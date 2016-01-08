//
//  CustomView.m
//  demo2
//
//  Created by Wikky on 15/10/30.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView



- (id)initWithFrame:(CGRect)frame insertColorGradientTop:(UIColor *)topColor buttomColor:(UIColor *)ButtomColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self insertColorGradientTop:(UIColor *)topColor buttomColor:(UIColor *)ButtomColor];
    }
    return self;
}

- (void) insertColorGradientTop:(UIColor *)topColor buttomColor:(UIColor *)buttomColor
{
    

    
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, buttomColor.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer above:0];
    
}
@end
