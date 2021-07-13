//
//  PushesViewController.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "PushesViewController.h"
#import "CreationViewController.h"
#import "Platform.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>

@interface PushesViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) NSArray *platforms;
@property (nonatomic) CGFloat *selectedCount;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
//@property (strong, nonatomic) UIViewController *creationVC;

@end

@implementation PushesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.taskTitle;
    self.ideaDumpLabel.text = self.ideaDump;
    [self.taskImageView setImage:self.taskImage];
    NSString *typeString = @"New ";
    typeString = [typeString stringByAppendingString:self.type];
    self.typeLabel.text = typeString;
    self.selectedCount = 0;
    [self.taskImageView.layer setCornerRadius:15];
    
    // Configure available platforms based on task type
    if ([self.type isEqualToString:@"long"]) {
        self.platforms = @[@"YouTube", @"Instagram"];
    } else if ([self.type isEqualToString:@"short"]) {
        self.platforms = @[@"YouTube", @"Instagram", @"TikTok"];
    } else {
        self.platforms = @[@"YouTube", @"Instagram", @"Snapchat", @"Twitter"];
    }
    
    // Display buttons in stack view for all platforms
    for (int i = 0; i < self.platforms.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.platforms[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
        [button.layer setCornerRadius:10];
        button.layer.borderWidth = 2.0f;
        button.layer.borderColor = [UIColor systemTealColor].CGColor;

        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsStack addArrangedSubview:button];
    }
}

// Configure platform button style and selected state
- (void)onTapPlatformButton:(UIButton*)sender {
    // Platform becomes selected
    if(!sender.selected) {
        sender.backgroundColor = [UIColor systemTealColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectedCount++;
    // Platform becomes unselected
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
        self.selectedCount--;
    }
    sender.selected = !sender.selected;
}

- (IBAction)onPost:(id)sender {
    // User must select at least one platform before proceeding
    if (self.selectedCount == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Platform Required"
            message:@"you must select at least one platform to push this task onto😊"
            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"got it!"
            style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        // Populate selectedPlatforms based on platform selected states
        NSArray *buttons = self.buttonsStack.arrangedSubviews;
        NSMutableDictionary *selectedPlatforms = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < buttons.count; i++) {
            UIButton *thisButton = (UIButton*)buttons[i];
            [selectedPlatforms setObject:@(thisButton.selected) forKey:thisButton.titleLabel.text];
        }
        
        [Task postTask:self.taskTitle withDescription:self.ideaDump withImage:self.taskImage withPlatforms:selectedPlatforms ofType:self.type withCompletion:nil];
        
        // Provide tips for user after posting
        if ([self.type isEqualToString:@"long"]) {
            [self showLongTip];
        } else if ([self.type isEqualToString:@"short"]) {
            [self showShortTip];
        } else {
            [self showStoryTip];
        }
        
        // TODO: make a reset creation method - some delegate thing
    }
}

- (void)showLongTip {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfully started task!💪"
        message:@"TIP: add story tasks to build up hype for this long!🔥"
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Go to creation if user wants to add another task
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok!"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[self presentViewController:self.creationVC animated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    [alert addAction:okAction];
    
    // Go to stream if user doesn't want to add another task
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"later"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showShortTip {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfully started task!💪"
        message:@"TIP: put the trending tags from the discover page on your shorts😎"
        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"got it!"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showStoryTip {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfully started task!💪"
        message:@"TIP: use polls and Q&As to engage your followers!🤩"
        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"got it!"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onTapEdit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
