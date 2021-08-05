//
//  ConfettiUtilities.h
//  contented
//
//  Created by Christine Sun on 8/4/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfettiUtilities : NSObject

+ (void) startConfettiForView: (UIView*)view forState: (NSString*) theState;
+ (NSMutableArray<CAEmitterCell*>*)getEmitterCells;
+ (void)stopConfetti;

@end

NS_ASSUME_NONNULL_END
