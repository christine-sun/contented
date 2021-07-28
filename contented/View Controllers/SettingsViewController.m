//
//  SettingsViewController.m
//  contented
//
//  Created by Christine Sun on 7/21/21.
//

#import "SettingsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "APIManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *youtubeIDField;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *completedTasksLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.usernameLabel.text = self.user[@"username"];
    [self.statusMessageLabel setTextColor:[UIColor whiteColor]];
    
    NSString *completedTasks = [NSString stringWithFormat:@"%d %@", [self getTotalTasksCompleted], @"tasks completed"];
    self.completedTasksLabel.text = completedTasks;
    NSString *userID = self.user[@"youtubeID"];
    self.youtubeIDField.text = userID;
    
    CGFloat profilePicDimension = 110;
    [self.profileImageView.layer setCornerRadius:profilePicDimension / 2];
    [APIManager setProfileImage:userID forImageView:self.profileImageView];
}

- (IBAction)onTapLogOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.view.window.rootViewController = loginVC;
    }];
}

- (IBAction)onTapUpdate:(id)sender {
    // Set the user's youtubeID
    PFUser *user = [PFUser currentUser];
    __block NSString *userID = self.youtubeIDField.text;
    user[@"youtubeID"] = userID;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.statusMessageLabel.text = @"Your YouTube ID has been updated!";
            [self.statusMessageLabel setTextColor:[UIColor systemGreenColor]];
            [APIManager setProfileImage:userID forImageView:self.profileImageView];
        }
        else {
            self.statusMessageLabel.text = @"There was a problem updating your YouTube ID.";
            [self.statusMessageLabel setTextColor:[UIColor systemRedColor]];
        }
    }];
}

- (int) getTotalTasksCompleted {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"completed" equalTo:@(1)];
    NSArray *completed = [query findObjects];
    return (int)completed.count;
}

- (void)dismissKeyboard {
    [self.youtubeIDField resignFirstResponder];
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
