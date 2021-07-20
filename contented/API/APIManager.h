//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>
#import "Video.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (NSDictionary*) fetchLast20Views: (NSString*) userID;
+ (void)setVideoViews: (Video*)video: (NSDictionary*)videoDict;
@end

NS_ASSUME_NONNULL_END
