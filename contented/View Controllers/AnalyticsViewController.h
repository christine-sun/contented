//
//  AnalyticsViewController.h
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsViewController : UIViewController

- (void) setOriginalVideos:(NSMutableArray *)originalVids;
- (void) setOriginalVals:(NSMutableArray *)originalValues;
- (void) setChart: (NSMutableArray*) values;

@end

NS_ASSUME_NONNULL_END
