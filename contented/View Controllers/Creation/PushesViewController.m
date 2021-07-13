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
@property (strong, nonatomic) NSDictionary *selectedPlatforms;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

@implementation PushesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.type = @"long"; //fortesting
//    if ([self.type isEqualToString:@"long"]) {
//        NSMutableArray *platforms = [NSMutableArray array];
//        [platforms addObject:[[Platform alloc] init]];
//        // NEED HELP: how should we handle the array of platformshttps://www.youtube.com/watch?v=cVBrbpJdgyg
//    }
    self.titleLabel.text = self.taskTitle;
    self.ideaDumpLabel.text = self.ideaDump;
    [self.taskImageView setImage:self.taskImage];
    NSString *typeString = @"New ";
    typeString = [typeString stringByAppendingString:self.type];
    self.typeLabel.text = typeString;
    
    if ([self.type isEqualToString:@"long"]) {
        //platforms will contain YouTube and IGTV
        self.platforms = @[@"YouTube", @"Instagram"];
    } else if ([self.type isEqualToString:@"short"]) {
        //platforms will contain YouTube, IG Reel, and TikTok
        self.platforms = @[@"YouTube", @"Instagram", @"TikTok"];
    } else {
        // it is a story. platforms will contain YouTube, IG, Snapchat, and Twitter
        self.platforms = @[@"YouTube", @"Instagram", @"Snapchat", @"Twitter"];
    }
    
    // based on platforms, display an array of buttons that right now, shows the text. next level: display image on button
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
    
}

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
    // If selectedPlatforms is empty, display an error message: Error - you must select at least one platform to push this task onto
    
    
    // The NSDictionary selectedPlatforms depends on which buttons are selected in the scrollview. This dictionary will have 1 if it is selected and 0 if it is not
    
    [Task postTask:self.taskTitle withDescription:self.ideaDump withImage:self.taskImage withPlatforms:self.selectedPlatforms ofType:self.type withCompletion:nil];
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
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
