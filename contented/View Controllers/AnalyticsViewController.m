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
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;

@property (strong, nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *queryPickerView;
@property (strong, nonatomic) NSArray *queryPickerData;

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up video count picker
    self.videoCountPicker.delegate = self;
    self.videoCountPicker.dataSource = self;
    self.videoCountPickerData = @[@"20", @"15", @"10", @"5"];
    
    // Set up query picker
    self.queryPickerView.delegate = self;
    self.queryPickerView.dataSource = self;
    self.queryPickerData = @[@"video count", @"date range"];
    
    // Hide date pickers initially because default is video count
    [self styleQueryByVideoCount];
    
    [APIManager setYouTubeReportLabel:self.ytReportLabel];
    [APIManager setRecommendationLabel:self.recommendationLabel];
    self.userID = [PFUser currentUser][@"youtubeID"];
    [APIManager fetchRecentViews:self.userID withVideoCount:self.videoCountPickerData[0]];
    [APIManager setDatePickers:self.startDatePicker end:self.endDatePicker];
    
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
        NSLog(@"%@", video.title);
        [self performSegueWithIdentifier:@"webSegue" sender:video];
    }
}

#pragma mark - Picker Views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.videoCountPicker) {
        return self.videoCountPickerData.count;
    } else {
        return self.queryPickerData.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.videoCountPicker) {
        return self.videoCountPickerData[row];
    } else {
        return self.queryPickerData[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.queryPickerView) {
        // Show video count picker and hide start and end date pickers
        if ([self.queryPickerData[row] isEqualToString:@"video count"]) {
            [self styleQueryByVideoCount];
        }
        // Show start and end date pickers and hide video count picker
        else {
            [self styleQueryByDate];
        }
    }
    [APIManager fetchRecentViews:self.userID withVideoCount:self.videoCountPickerData[row]];
}

- (void)styleQueryByVideoCount {
    self.videoCountLabel.alpha = 1;
    self.videoCountPicker.alpha = 1;
    self.videoCountPicker.userInteractionEnabled = YES;
    
    self.startDatePicker.alpha = 0;
    self.startDatePicker.userInteractionEnabled = NO;
    self.endDatePicker.alpha = 0;
    self.endDatePicker.userInteractionEnabled = NO;
}

- (void)styleQueryByDate {
    self.videoCountLabel.alpha = 0;
    self.videoCountPicker.alpha = 0;
    self.videoCountPicker.userInteractionEnabled = NO;
    
    self.startDatePicker.alpha = 1;
    self.startDatePicker.userInteractionEnabled = YES;
    self.endDatePicker.alpha = 1;
    self.endDatePicker.userInteractionEnabled = YES;
}

#pragma mark - Video Date Range Pickers

- (IBAction)onChangeStartDate:(id)sender {
    [self updateVids];
}

- (IBAction)onChangeEndDate:(id)sender {
    [self updateVids];
}

- (void)updateVids {
    NSMutableArray *vids = [NSMutableArray arrayWithArray:[APIManager getVids]];
    NSMutableArray *modifiedVids = [NSMutableArray arrayWithArray:vids];
    double ySum = [APIManager getYSum];
    for (Video* video in vids) {
        NSLog(@"%@ | %@", vids, video);
        if (([video.publishedAt compare:self.startDatePicker.date] < 0) || ([video.publishedAt compare:self.endDatePicker.date] > 0)) {
            [modifiedVids removeObject:video];
            ySum -= video.views;
        }
    }
    [APIManager setYSum:ySum];
    [APIManager setVids:modifiedVids];
    [APIManager setChartValues];
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
