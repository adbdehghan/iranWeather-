//
//  Gradient.m
//  Iran Weather
//
//  Created by aDb on 12/8/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "Gradient.h"

@implementation Gradient

-(UIImage*)CreateGradient:(int)width Height:(int)height
{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientLocations[2] = { 0.0, 1.0 };
    CGFloat gradientComponents[8] = {0.2, .6, 1,1,  // Start color
          .1, .85, .9, .5};  // End color
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}
@end

