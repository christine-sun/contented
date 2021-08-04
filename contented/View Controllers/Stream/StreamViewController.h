//
//  StreamViewController.h
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreamViewController : UIViewController<TaskCellDelegate>

- (void)startConfetti;

@end

NS_ASSUME_NONNULL_END
