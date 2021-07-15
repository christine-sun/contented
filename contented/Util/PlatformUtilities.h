//
//  PlatformUtilities.h
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformUtilities : NSObject

+ (NSArray*) getPlatformsForType:(NSString*) type;

@end

NS_ASSUME_NONNULL_END
