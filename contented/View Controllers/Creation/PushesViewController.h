//
//  PushesViewController.h
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushesViewController : UIViewController

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *ideaDump;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIImage *taskImage;

@end

NS_ASSUME_NONNULL_END
