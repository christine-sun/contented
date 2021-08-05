//
//  DesignUtilities.m
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import "DesignUtilities.h"

@implementation DesignUtilities

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
    } else if ([type isEqualToString:@"light blue"]){
        return [UIColor colorWithRed:145.0f/255.0f
                               green:217.0f/255.0f
                               blue:255.0f/255.0f
                               alpha:1.0f];
    }
    else {
        return [UIColor colorWithRed:187.0f/255.0f
                               green:153.0f/255.0f
                               blue:255.0f/255.0f
                               alpha:1.0f];
    }
}

+ (void) addShadow:(UIView*)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 2;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}

+ (void) fadeIn:(UIView*)view withDuration: (NSTimeInterval) time {
    view.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        view.alpha = 1;
    }];
    
}

@end
