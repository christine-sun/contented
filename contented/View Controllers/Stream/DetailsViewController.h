//
//  DetailsViewController.h
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Task *task;

@end

NS_ASSUME_NONNULL_END
