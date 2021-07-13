//
//  PushesViewController.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "PushesViewController.h"
#import "Platform.h"
#import "Task.h"

@interface PushesViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) NSArray *platforms;
@property (strong, nonatomic) NSMutableArray *selectedPlatforms;
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
    } else if ([self.type isEqualToString:@"short"]) {
        //platforms will contain YouTube, IG Reel, and TikTok
    } else {
        // it is a story. platforms will contain YouTube, IG, Snapchat, and Twitter
    }
    
// The NSMutableArray selectedPlatforms depends on which buttons are selected in the scrollview. This array is passed over when user posts
}

- (IBAction)onPost:(id)sender {
    // If selectedPlatforms is empty, display an error message: Error - you must select at least one platform to push this task onto
    
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
