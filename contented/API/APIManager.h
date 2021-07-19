//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (NSDictionary*) fetchLast20Videos: (NSString*) userID;
+ (NSNumber*) fetchViewCount: (NSString*) videoID;
+ (NSNumber*) fetchSubCount: (NSString*) userID;
+ (NSDictionary*) fetchInitialDictionary: (NSString*) URL;

@end

NS_ASSUME_NONNULL_END
