//
//  ColorUtilities.m
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import "ColorUtilities.h"

@implementation ColorUtilities

+ (UIColor *) getColorFor:(NSString*) type {
    if ([type isEqualToString:@"long"]) {
        return [UIColor colorWithRed:255.0f/255.0f
                               green:153.0f/255.0f
                               blue:153.0f/255.0f
                               alpha:1.0f];
    } else if ([type isEqualToString:@"short"]) {
        return [UIColor colorWithRed:124.0f/255.0f
                               green:255.0f/255.0f
                               blue:196.0f/255.0f
                               alpha:1.0f];
    } else if ([type isEqualToString:@"post"]){
        return [UIColor colorWithRed:255.0f/255.0f
                               green:248.0f/255.0f
                               blue:112.0f/255.0f
                               alpha:1.0f];
    } else if ([type isEqualToString:@"blue"]) {
        return [UIColor systemTealColor];
    } else {
        return [UIColor colorWithRed:187.0f/255.0f
                               green:153.0f/255.0f
                               blue:255.0f/255.0f
                               alpha:1.0f];
    }
}

@end
