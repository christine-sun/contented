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

+ (void)setLabel:(UILabel*)otherLabel;
+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel;
+ (UILabel*)getYTReportLabel;
+ (UILabel*)getLabel;
+ (NSDictionary*) fetchLast20Views: (NSString*) userID;
+ (NSMutableArray*) getVids;
+ (void)setVideoViews: (Video*)video: (NSDictionary*)videoDict;
+ (void)setChart: (LineChartView*) lineChartView;
+ (void)setChartValues;
+ (NSDate*) stringToDate:(NSString*) dateString;
@end

NS_ASSUME_NONNULL_END
