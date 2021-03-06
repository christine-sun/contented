//
//  SignUpViewController.m
//  contented
//
//  Created by Christine Sun on 8/4/21.
//

#import "SignUpViewController.h"
#import "DesignUtilities.h"
#import <Parse/Parse.h>
#import "GuideViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.signUpButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.signUpButton.layer setCornerRadius:20];
    self.signUpButton.backgroundColor = [DesignUtilities getColorFor:@"light blue"];
    [self styleShadow:self.signUpButton];
    
    [self styleShadow:self.usernameField];
    [self increaseHeight:self.usernameField];
    [self styleShadow:self.emailField];
    [self increaseHeight:self.emailField];
    [self styleShadow:self.passwordField];
    [self increaseHeight:self.passwordField];
    [self styleShadow:self.confirmPasswordField];
    [self increaseHeight:self.confirmPasswordField];
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)styleShadow: (UIView*) view {
    [DesignUtilities addShadow:view];
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
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
}

- (IBAction)onTapSignUp:(id)sender {
    // Ensure password and confirm password match
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Signing Up"
            message:@"The password and confirmation password must match"
            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok"
            style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self performSegueWithIdentifier:@"guideSegue" sender:nil];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Signing Up"
                            message:error.localizedDescription
                            preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok"
                            style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
        }];
    }
}

- (IBAction)onTapDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapSignIn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"guideSegue"]) {
        GuideViewController *guideVC = [segue destinationViewController];
        guideVC.state = 1;
    }
}

@end
