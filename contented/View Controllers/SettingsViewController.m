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

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *youtubeIDField;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (strong, nonatomic) PFUser *user;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    
    [self.statusMessageLabel setTextColor:[UIColor whiteColor]];
//    self.youtubeIDField.text = self.user.youtubeID;
    self.youtubeIDField.text = self.user[@"youtubeID"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
       // User is logged in, do work such as go to next view controller.
      }
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
      // Optional: Place the button in the center of your view.
      loginButton.center = self.view.center;
      [self.view addSubview:loginButton];
    loginButton.permissions = @[@"instagram_basic", @"pages_show_list"];
    //    // Configure Google Sign-in.
    //    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    //    signIn.delegate = self;
    //    signIn.uiDelegate = self;
    //    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTubeReadonly, nil];
    ////    [signIn signInSilently];
    //
    //    // Add the sign-in button.
    //    self.signInButton = [[GIDSignInButton alloc] init];
    //    [self.view addSubview:self.signInButton];
    //
    //    // Create a UITextView to display output.
    //    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    //    self.output.editable = false;
    //    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    //    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //    self.output.hidden = true;
    //    [self.view addSubview:self.output];
    //
    //    // Initialize the service object.
    //    self.service = [[GTLRYouTubeService alloc] init];
    /* Your app can only have one person logged in at a time. We represent each person logged into your app with the [FBSDKAccessToken currentAccessToken].
     The FBSDKLoginManager sets this token for you and when it sets currentAccessToken it also automatically writes it to a keychain cache.
     The FBSDKAccessToken contains userID which you can use to identify the user.
     You should update your view controller to check for an existing token at load. This avoids unnecessary showing the login flow again if someone already granted permissions to your app: */
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
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    PFUser *user = [PFUser currentUser];
    user[@"youtubeID"] = self.youtubeIDField.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.statusMessageLabel.text = @"Your YouTube ID has been updated!";
            [self.statusMessageLabel setTextColor:[UIColor systemGreenColor]];
        }
        else {
            self.statusMessageLabel.text = @"There was a problem updating your YouTube ID.";
            [self.statusMessageLabel setTextColor:[UIColor systemRedColor]];
        }
    }];
}


// google begin
- (IBAction)onTapSignIn:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        NSLog(@"%@", error.localizedDescription);
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchChannelResource];
    }
}

// Construct a query and retrieve the channel resource for the GoogleDevelopers
// YouTube channel. Display the channel title, description, and view count.
- (void)fetchChannelResource {
    GTLRYouTubeQuery_ChannelsList *query =
    [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    query.identifier = @"UC_x5XG1OV2P6uZZ5FSM9Ttw";
  // To retrieve data for the current user's channel, comment out the previous
  // line (query.identifier ...) and uncomment the next line (query.mine ...).
  // query.mine = true;

    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRYouTube_ChannelListResponse *)channels
                          error:(NSError *)error {
  if (error == nil) {
    NSMutableString *output = [[NSMutableString alloc] init];
    if (channels.items.count > 0) {
      [output appendString:@"Channel information:\n"];
      for (GTLRYouTube_Channel *channel in channels) {
        NSString *title = channel.snippet.title;
        NSString *description = channel.snippet.description;
        NSNumber *viewCount = channel.statistics.viewCount;
        [output appendFormat:@"Title: %@\nDescription: %@\nViewCount: %@\n", title, description, viewCount];
      }
    } else {
      [output appendString:@"Channel not found."];
    }
    self.output.text = output;
  } else {
    [self showAlert:@"Error" message:error.localizedDescription];
  }
}


// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
// google end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
