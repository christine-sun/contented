//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>
#import "Video.h"
@class UILabel;
@import Charts;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel;
+ (NSDictionary*) fetchRecentViews: (NSString*) userID withVideoCount: (NSString*) vidCount;
+ (NSMutableArray*) getVids;
+ (void)setVideoViews: (Video*)video: (NSDictionary*)videoDict;
+ (void)setRecommendationLabel:(UILabel*)recommendationLabel;
+ (void)setChart: (LineChartView*) lineChartView;
+ (void)setChartValues;
+ (NSDate*) stringToDate:(NSString*) dateString;
+ (void) setProfileImage: (NSString*) userID forImageView: (UIImageView*) imageView;
@end

NS_ASSUME_NONNULL_END
