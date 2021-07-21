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
//#import "Charts/Charts-Swift.h"

@interface AnalyticsViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextField *userIDLabel;
@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;

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

    [APIManager setLabel:self.testLabel];
    
//    NSString *userID = @"UCt7gY0riLR5YJLISl3RK5iw"; // soon user can input by themselves
    [self updateVideoInfo];
    
    
    //chart begin
    self.lineChartView.delegate = self;

    self.lineChartView.dragEnabled = YES;
    [self.lineChartView setScaleEnabled:YES];
    self.lineChartView.pinchZoomEnabled = YES;

    self.lineChartView.rightAxis.enabled = NO;
    [self.lineChartView animateWithXAxisDuration:2.5];
    [APIManager setChart:self.lineChartView];
//    [APIManager setChartValues:self.lineChartView];
    
}

//- (void)setChartValues {
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 20; i++) {
//        [values addObject:[[ChartDataEntry alloc] initWithX:i y:(i*5)]];
//    }
//    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithEntries:values label:@"test 1"];
//    set1.drawCirclesEnabled = YES;
//    [set1 setColor:UIColor.blackColor];
//    [set1 setCircleColor:UIColor.redColor];
//    set1.lineWidth = 1.0;
//    set1.circleRadius = 3.0;
//    set1.drawCircleHoleEnabled = YES;
//
//    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//    [dataSets addObject:set1];
//    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//    self.lineChartView.data = data;
//}

// end attempt to add chart

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
