//
//  SettingsViewController.m
//  contented
//
//  Created by Christine Sun on 7/21/21.
//

#import "SettingsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([FBSDKAccessToken currentAccessToken]) {
       // User is logged in, do work such as go to next view controller.
      }
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
      // Optional: Place the button in the center of your view.
      loginButton.center = self.view.center;
      [self.view addSubview:loginButton];
    loginButton.permissions = @[@"instagram_basic", @"pages_show_list"];
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
