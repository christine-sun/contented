//
//  EditViewController.h
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditViewControllerDelegate

- (void)didUpdate:(Task*) task;

@end

@interface EditViewController : UIViewController

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id<EditViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
