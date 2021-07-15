//
//  DetailsViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.task.title;
    self.ideaDumpLabel.text = self.task.ideaDump;
    NSDate *dueDate = self.task.dueDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE MM/dd"];
    NSString *preText = @"Release on ";
    self.dateLabel.text = [preText stringByAppendingString:[weekday stringFromDate:dueDate]];
    
    // Display buttons in stack view for corresponding platforms
    //[self.buttonsStack.heightAnchor constraintEqualToConstant:80].active = YES;
    NSDictionary *platforms = self.task.platforms;
 
    [platforms enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        // key is social media platform, obj is TRUE or FALSE
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:key forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button.heightAnchor constraintEqualToConstant:60].active = YES;
        
        if ([obj integerValue] == 0) {
            // The task has not been completed yet
            [button setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
            [button.layer setCornerRadius:10];
            button.layer.borderWidth = 2.0f;
            button.layer.borderColor = [UIColor systemTealColor].CGColor;
        } else {
            // The task has been completed
            button.backgroundColor = [UIColor systemTealColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsStack addArrangedSubview:button];
    }];
    
}

- (void)onTapPlatformButton:(UIButton*)sender {
    // Platform becomes selected
    if(!sender.selected) {
        sender.backgroundColor = [UIColor systemTealColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Platform becomes unselected
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
