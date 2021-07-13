//
//  PushesViewController.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "PushesViewController.h"
#import "Platform.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>

@interface PushesViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) NSArray *platforms;
@property (strong, nonatomic) NSMutableDictionary *selectedPlatforms;
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

        [button addTarget:self action: @selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsStack addArrangedSubview:button];
    }
    
    self.selectedPlatforms = [[NSMutableDictionary alloc] init];
    
}

// Configure platform button style and selected state
- (void)onTapButton:(UIButton*)sender {
    if(!sender.selected) {
        sender.backgroundColor = [UIColor systemTealColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
}

- (IBAction)onPost:(id)sender {
    // User must select at least one platform before proceeding
    if (self.selectedPlatforms.count == 0) {
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
        for (int i = 0; i < buttons.count; i++) {
            UIButton *thisButton = (UIButton*)buttons[i];
            NSLog(@"%d", thisButton.selected);
            NSLog(@"%@", thisButton.titleLabel.text);
            [self.selectedPlatforms setObject:@(thisButton.selected) forKey:thisButton.titleLabel.text];
            NSLog(@"%d", [[self.selectedPlatforms objectForKey:thisButton.titleLabel.text] intValue]);
        }
        
        [Task postTask:self.taskTitle withDescription:self.ideaDump withImage:self.taskImage withPlatforms:self.selectedPlatforms ofType:self.type withCompletion:nil];
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    }
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
