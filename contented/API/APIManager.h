//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>
#import "Video.h"
@class UILabel;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (void)setLabel:(UILabel*)otherLabel;
+ (UILabel*)getLabel;
+ (NSDictionary*) fetchLast20Views: (NSString*) userID;
+ (void)setVideoViews: (Video*)video: (NSDictionary*)videoDict;
@end

NS_ASSUME_NONNULL_END
