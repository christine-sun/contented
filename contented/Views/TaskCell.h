//
//  TaskCell.h
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskCellDelegate;

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic, weak) id<TaskCellDelegate> delegate;

@end

@protocol TaskCellDelegate
- (void)taskCell:(TaskCell *) taskCell didTap: (Task*) task;
@end

NS_ASSUME_NONNULL_END
