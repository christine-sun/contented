//
//  APIManager.h
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import <Foundation/Foundation.h>
#import "Video.h"
#import "AnalyticsViewController.h"
@class UILabel;
@import Charts;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel;
+ (void)setAnalyticsVC:(AnalyticsViewController*)analyticsViewController;
+ (NSMutableArray*) getVids;
+ (void) setVids: (NSMutableArray*) videos;
+ (double) getYSum;
+ (void) setYSum: (double)newYSum;
+ (void)setRecommendationLabel:(UILabel*)recommendationLabel;
+ (void)setDatePickers:(UIDatePicker*)start end:(UIDatePicker*)end;
+ (NSDictionary*) fetchRecentViews: (NSString*) userID withVideoCount: (NSString*) vidCount;
+ (void)setVideoViews: (Video*)video: (NSDictionary*)videoDict;
+ (void)setChart: (LineChartView*) lineChartView;
+ (void)setChartValues;
+ (NSDate*) stringToDate:(NSString*) dateString;
+ (void) setProfileImage: (NSString*) userID forImageView: (UIImageView*) imageView;

@end

NS_ASSUME_NONNULL_END
