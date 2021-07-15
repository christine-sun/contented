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
#import "PlatformUtilities.h"
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
    self.platforms = [PlatformUtilities getPlatformsForType:self.type];
    
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
        
        // Populate selectedPlatforms with the selected platforms
        // All platforms have value of FALSE because they are not completed yet
        NSArray *buttons = self.buttonsStack.arrangedSubviews;
        NSMutableDictionary *selectedPlatforms = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < buttons.count; i++) {
            UIButton *thisButton = (UIButton*)buttons[i];
            if (thisButton.selected) {
                [selectedPlatforms setObject:@NO forKey:thisButton.titleLabel.text];
            }
        }
        
        [Task postTask:self.taskTitle withDescription:self.ideaDump withDate:self.date withImage:self.taskImage withPlatforms:selectedPlatforms ofType:self.type withCompletion:nil];
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        
        // Provide tips for user after posting
        if ([self.type isEqualToString:@"long"]) {
            [self showLongTip];
        } else if ([self.type isEqualToString:@"short"]) {
            [self showShortTip];
        } else {
            [self showStoryTip];
        }
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)showLongTip {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successfully started task!💪"
        message:@"TIP: add story tasks to build up hype for this long!🔥"
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Go to creation if user wants to add another task
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok!"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    [alert addAction:okAction];
    
    // Go to stream if user doesn't want to add another task
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"later"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:NO];
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
            [self.navigationController popToRootViewControllerAnimated:NO];
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
            [self.navigationController popToRootViewControllerAnimated:NO];
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
