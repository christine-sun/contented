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

@interface AnalyticsViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIDLabel;
@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UILabel *ytReportLabel;

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [APIManager setYouTubeReportLabel:self.ytReportLabel];
    
    [self updateVideoInfo];
    
    // Set up the chart
    UITapGestureRecognizer *pointTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPoint:)];
    [self.lineChartView addGestureRecognizer:pointTapGestureRecognizer];
    self.lineChartView.delegate = self;
    self.lineChartView.dragEnabled = YES;
    [self.lineChartView setScaleEnabled:YES];
    self.lineChartView.pinchZoomEnabled = YES;
    self.lineChartView.xAxis.enabled = NO;
    self.lineChartView.leftAxis.enabled = NO;
    self.lineChartView.rightAxis.enabled = NO;
    [self.lineChartView animateWithXAxisDuration:2.5];
    [APIManager setChart:self.lineChartView];

    // select time period and total number of recent videos

}

- (void) didTapPoint:(UITapGestureRecognizer*)sender {
    if (sender.state == UIPressPhaseEnded) {
        CGPoint touchPoint = [sender locationInView:self.view];
        ChartHighlight *highlight = [self.lineChartView getHighlightByTouchPoint:touchPoint];
        NSString *haystack = [NSString stringWithFormat:@"%@", highlight];
        NSString *haystackPrefix = @"Highlight, x: ";
        NSString *haystackSuffix = @".0, y:";
        NSRange needleRange = NSMakeRange(haystackPrefix.length,
                                          haystack.length - haystackPrefix.length - haystackSuffix.length);
        NSString *needle = [haystack substringWithRange:needleRange];
        NSArray *haystackArray = [needle componentsSeparatedByString:@".0"];
        NSString *indexString = haystackArray[0];
        NSInteger index = [indexString integerValue];
    
        // Send tapped point's video information to web view
        Video *video = [APIManager getVids][index];
        [self performSegueWithIdentifier:@"webSegue" sender:video];
    }
}

- (void)updateVideoInfo {
    NSString *userID = [PFUser currentUser][@"youtubeID"];
    [APIManager fetchLast20Views:userID];
}

- (IBAction)onTapUpdate:(id)sender {
    [self updateVideoInfo];
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
