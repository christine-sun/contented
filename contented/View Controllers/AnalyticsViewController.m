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

@interface AnalyticsViewController () <ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UILabel *ytReportLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendationLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *videoCountPicker;
@property (strong, nonatomic) NSArray *videoCountPickerData;
@property (strong, nonatomic) NSString *userID;

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up video count picker
    self.videoCountPicker.delegate = self;
    self.videoCountPicker.dataSource = self;
    self.videoCountPickerData = @[@"20", @"15", @"10", @"5"];
    
    [APIManager setYouTubeReportLabel:self.ytReportLabel];
    [APIManager setRecommendationLabel:self.recommendationLabel];
    self.userID = [PFUser currentUser][@"youtubeID"];
    [APIManager fetchRecentViews:self.userID withVideoCount:self.videoCountPickerData[0]];
    
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

#pragma mark - Video Count Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.videoCountPickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.videoCountPickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [APIManager fetchRecentViews:self.userID withVideoCount:self.videoCountPickerData[row]];

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
