//
//  ColorUtilities.h
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorUtilities : NSObject

+ (UIColor *) getColorFor:(NSString*) type;

@end

NS_ASSUME_NONNULL_END
