//
//  DesignUtilities.h
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignUtilities : NSObject

+ (UIColor *) getColorFor:(NSString*) type;
+ (void) addShadow:(UIView*)view;
+ (void) fadeIn:(UIView*)view withDuration: (NSTimeInterval) time;

@end

NS_ASSUME_NONNULL_END
