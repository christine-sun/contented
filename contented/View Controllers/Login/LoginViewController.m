//
//  LoginViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ColorUtilities.h"
//#import <Shimmer/Shimmer.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.loginButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.loginButton.layer setCornerRadius:20];
    self.loginButton.backgroundColor = [ColorUtilities getColorFor:@"light blue"];
    [self styleShadow:self.loginButton];
    
    [self styleShadow:self.usernameField];
    [self increaseHeight:self.usernameField];
    
    [self styleShadow:self.passwordField];
    [self increaseHeight:self.passwordField];
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)styleShadow: (UIView*) view {
    [ColorUtilities addShadow:view];
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowRadius = 4;
}

- (void)increaseHeight: (UITextField*)field {
    CGRect frameRect = field.frame;
    frameRect.size.height = 50;
    field.frame = frameRect;
}

-(void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)onTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

- (IBAction)onTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
            
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (user) {
            [self configureRoot];
        }
    }];
}

-(void)configureRoot {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.view.window.rootViewController = rootVC;
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
