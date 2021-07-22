//
//  AnalyticsViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "AnalyticsViewController.h"
#import <Parse/Parse.h>
#import "APIManager.h"
@import Charts;
#import "Video.h"
#import "WebViewController.h"

//#import "Charts/Charts-Swift.h"

@interface AnalyticsViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextField *userIDLabel;
@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UILabel *ytReportLabel;

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    UITapGestureRecognizer *pointTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPoint:)];
    [self.lineChartView addGestureRecognizer:pointTapGestureRecognizer];
    
    [APIManager setLabel:self.testLabel];
    [APIManager setYouTubeReportLabel:self.ytReportLabel];
    
    [self updateVideoInfo];
    
    //chart begin
    self.lineChartView.delegate = self;
    self.lineChartView.dragEnabled = YES;
    [self.lineChartView setScaleEnabled:YES];
    self.lineChartView.pinchZoomEnabled = YES;
    self.lineChartView.xAxis.enabled = NO;
    self.lineChartView.leftAxis.enabled = NO;
    self.lineChartView.rightAxis.enabled = NO;
    [self.lineChartView animateWithXAxisDuration:2.5];
    [APIManager setChart:self.lineChartView];
    
}

- (void) didTapPoint:(UITapGestureRecognizer*)sender {
    NSLog(@"Tapped on a point");
    if(sender.state == UIPressPhaseEnded) {
        CGPoint touchPoint = [sender locationInView:self.view];
        ChartHighlight *highlight = [self.lineChartView getHighlightByTouchPoint:touchPoint];
        NSLog(@"%@", highlight);
        NSString *haystack = [NSString stringWithFormat:@"%@", highlight];
        NSLog(@"%@", haystack);
        // the x of highlight is the correct index
        
        NSString *haystackPrefix = @"Highlight, x: ";
        NSString *haystackSuffix = @".0, y:";
        NSRange needleRange = NSMakeRange(haystackPrefix.length,
                                          haystack.length - haystackPrefix.length - haystackSuffix.length);
        NSString *needle = [haystack substringWithRange:needleRange];
        NSArray *haystackArray = [needle componentsSeparatedByString:@".0"];
        NSString *indexString = haystackArray[0];
        NSInteger index = [indexString integerValue];
    
        // TODO: NOW, index is the correct x index. Turn it into an int value, and then access the (i think its vids) which video is it? and find the youtube link using the vidoe id, and attach a webkit view
        Video *video = [APIManager getVids][index];
        
        [self performSegueWithIdentifier:@"webSegue" sender:video];
    }
    /* // Navigate to tapped user's profile
     - (void) didTapUserProfile:(UITapGestureRecognizer *)sender {
         [self.delegate tweetCell:self didTap:self.tweet.user];
     }*/
}

- (void)updateVideoInfo {
    NSString *userID = self.userIDLabel.text;
    NSLog(@"%@", userID);
    [APIManager fetchLast20Views:userID];
}

- (IBAction)onTapUpdate:(id)sender {
    [self updateVideoInfo];
}

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

- (IBAction)onTapLogOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.view.window.rootViewController = loginVC;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"webSegue"]) {
        WebViewController *webVC = [segue destinationViewController];
        webVC.video = (Video*) sender;
    }
}

@end
