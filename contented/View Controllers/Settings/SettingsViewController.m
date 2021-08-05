//
//  SettingsViewController.m
//  contented
//
//  Created by Christine Sun on 7/21/21.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "APIManager.h"
#import "WebViewController.h"

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
    if ([userID isEqualToString:@""]) {
        [self.youtubeIDField setBorderStyle:UITextBorderStyleRoundedRect];
    } else {
        [self.youtubeIDField setBorderStyle:UITextBorderStyleNone];
    }
    
    CGFloat profilePicDimension = 110;
    [self.profileImageView.layer setCornerRadius:profilePicDimension / 2];
    [APIManager setProfileImage:userID forImageView:self.profileImageView];
}

- (IBAction)onTapLogOut:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?"
        message:nil
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"yes"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                self.view.window.rootViewController = loginVC;
            }];
        }];
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"no"
        style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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

- (IBAction)onTapFindIDButton:(id)sender {
    [self performSegueWithIdentifier:@"webSegue" sender:nil];
}

- (void)dismissKeyboard {
    [self.youtubeIDField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"webSegue"]) {
        WebViewController *webVC = [segue destinationViewController];
        webVC.video = nil;
    }
}

@end
