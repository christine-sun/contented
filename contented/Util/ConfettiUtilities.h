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

+ (void) startEmitterForView: (UIView*)view;
+ (NSMutableArray<CAEmitterCell*>*)getEmitterCells;
+ (void)stopEmitter;

@end

NS_ASSUME_NONNULL_END
