//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
+ (void) testGetVideos: (NSString*) userID;
+ (NSDictionary*) fetchLast20Videos: (NSString*) userID;
+ (NSNumber*) fetchViewCount: (NSString*) videoID;
+ (NSNumber*) fetchSubCount: (NSString*) userID;
+ (void) fetchInitialDictionary;
+ (NSDictionary*) fetchLast20Views;
+ (NSString*) get20VidsURL : (NSString*) userID;
+ (NSDictionary*) testLast20Views;
+ (void)fetchInitDictionary : (NSString*) URL : (int) state;
+ (int)fetchViewsForID: (NSString*) vidID;
+ (NSDictionary*)gotVidsDictionary:(NSNotification *)notif;
+(void)fetch20Views;
+(void)gotViewsDictionary ;
+ (void)getViews:(NSNotification *)note;
+ (NSString*) getViewsURL : (NSString*) vidID;

@end

NS_ASSUME_NONNULL_END
