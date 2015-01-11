//
//  VisualEffects.m
//  Iran Weather
//
//  Created by aDb on 1/1/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import "SnowFall.h"
#import <QuartzCore/CoreAnimation.h>

@implementation SnowFall

-(void)startSnowFall:(BOOL)isDay Speed:(NSInteger)speed Amount:(CGFloat)amount Acceleration:(CGFloat)acceleration{
    
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width/2, -40);
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerOutline;
    snowEmitter.emitterShape	= kCAEmitterLayerLine;
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    snowflake.birthRate		= amount;
    snowflake.lifetime		= 120.0;
    
    snowflake.velocity		= speed;				// falling down slowly
    snowflake.velocityRange = 100;
    snowflake.yAcceleration = acceleration;
    snowflake.emissionRange = 0.5 * M_PI;		// some variation in angle
    snowflake.spinRange		= 0.25 * M_PI;		// slow spin
    snowflake.scale				= 0.1;
    snowflake.contents		= (id) [[UIImage imageNamed:@"spark"] CGImage];
    snowflake.color			= [[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    // snowEmitter.shadowOpacity = 1.0;
    //snowEmitter.shadowRadius  = 0.0;
    // snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    //  snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    if (isDay) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    else
        self.view.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1];
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view setClipsToBounds:YES];
    [self.view.layer insertSublayer:snowEmitter atIndex:1];
}
@end
