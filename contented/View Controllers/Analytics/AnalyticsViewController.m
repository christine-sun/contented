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
#import "DesignUtilities.h"

@interface AnalyticsViewController () <ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UILabel *ytReportLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendationLabel;
@property (strong, nonatomic) NSMutableArray *originalValues;
@property (strong, nonatomic) NSMutableArray *originalVids;
@property (strong, nonatomic) NSMutableArray *modifiedQueryVids;
@property (strong, nonatomic) NSString *userID;

@property (weak, nonatomic) IBOutlet UIPickerView *videoCountPicker;
@property (strong, nonatomic) NSArray *videoCountPickerData;
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeLabel;

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
    [APIManager setAnalyticsVC:self];
    [APIManager setRecommendationLabel:self.recommendationLabel];
    [APIManager setDatePickers:self.startDatePicker end:self.endDatePicker];
    
    self.userID = [PFUser currentUser][@"youtubeID"];
    if ([self.userID isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid ID"
            message:@"It looks like you haven't set your YouTube ID yet!"
            preferredStyle:(UIAlertControllerStyleAlert)];
        // Go to profile if user wants to set ID
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Set ID"
            style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        [alert addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"later"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [APIManager fetchRecentViews:self.userID withVideoCount:self.videoCountPickerData[0]];
    }
    
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
    [DesignUtilities fadeIn:self.lineChartView withDuration:2];
    [DesignUtilities fadeIn:self.recommendationLabel withDuration:2.5];
}

- (void) setOriginalVideos:(NSMutableArray *)originalVids {
    if (self.originalVids == nil) {
        self.originalVids = originalVids;
    }
}

#pragma mark - Line Chart View

- (void) setChart: (NSMutableArray*) vids {
    CGFloat maxViews = LONG_MIN;
    NSString *maxViewTitle = @"";
    double xSum = 0;
    for (int i = 0; i < vids.count; i++) {
        xSum += i;
    }
    double xMean = xSum / vids.count;
    double yMean = [APIManager getYSum] / vids.count;
    double numerator = 0; // find numerator in least squares equation
    double denominator = 0; // find denominator in least squares equation
    
    // Sort vids such that the video dates are in ascending order
    vids = [vids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
        return [a.publishedAt compare:b.publishedAt];
    }];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < vids.count; i++) {
        Video *video = vids[i];
        if (video.views > maxViews) {
            maxViews = video.views;
            maxViewTitle = video.title;
        }
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:video.views]];
        numerator += ((i - xMean) * (video.views - yMean));
        denominator += ((i - xMean)*(i - xMean));
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithEntries:values label:@"Views"];
    
    set1.drawCirclesEnabled = YES;
    [set1 setValueFont:[UIFont fontWithName:@"Avenir" size:8]];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.redColor];
    set1.lineWidth = 1.0;
    set1.mode = LineChartModeCubicBezier;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    self.lineChartView.data = data;
    
    // Display message about performance based on slope
    double slope = numerator / denominator;
    if (slope < -50) {
        [self.ytReportLabel setText:@"Consider what types of videos did well for your channel in the past - are there ways to rekindle that creativity and inspiration?"];
    }
    else if (slope > 50) {
        [self.ytReportLabel setText:@"Wow, you have been doing amazing! Keep on pushing out creative content 🔥"];
    }
    else {
        [self.ytReportLabel setText:@"Your views have been consistent! Consider bringing in new ideas to your channel to reach a new audience :)"];
    }
    
    self.recommendationLabel.text = [NSString stringWithFormat:@"Your best performing video in this time period was %@🔥\nLet's think together... 🤔\n 😲 What was special about this video?\n ☁️ What are some other videos you can make that follow the captivating themes of this one?", maxViewTitle];
    
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
    
        self.originalVids = [self.originalVids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
            return [a.publishedAt compare:b.publishedAt];
        }];
        self.modifiedQueryVids = [self.modifiedQueryVids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
            return [a.publishedAt compare:b.publishedAt];
        }];
        
        // Send tapped point's video information to web view
        __block Video *video;
        if (self.modifiedQueryVids == nil) {
            video = self.originalVids[index];
        } else {
            video = self.modifiedQueryVids[index];
        }
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
        [self setChart:self.originalVids];
    } else if (pickerView == self.videoCountPicker) {
        // fetch the x most recent views
        self.modifiedQueryVids = [self getSubsetOfOriginalVids:self.videoCountPickerData[row]];
        [self setChart:self.modifiedQueryVids];
        
    }
}

- (NSMutableArray*) getSubsetOfOriginalVids:(NSString*) vidCount {
    NSInteger videoCount = [vidCount integerValue];
    NSMutableArray *subset = [[NSMutableArray alloc] init];
    double removedYSum = 0;
    NSInteger totalVids = self.originalVids.count;
    self.originalVids = [self.originalVids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
        return [a.publishedAt compare:b.publishedAt];
    }];
    
    if (videoCount > 15) {
        return self.originalVids;
    }
    
    for (int i = totalVids - videoCount; i < totalVids; i++) {
        [subset addObject:self.originalVids[i]];
    }
    
    for (int i = 0; i < totalVids - videoCount; i++) {
        Video *vid = self.originalVids[i];
        removedYSum += vid.views;
    }
    
    [APIManager setYSum:[APIManager getYSum] - removedYSum];
    
    return subset;
}

- (void)styleQueryByVideoCount {
//    self.videoCountLabel.alpha = 1;
//    self.videoCountPicker.alpha = 1;
//    self.videoCountPicker.userInteractionEnabled = YES;
    
    self.dateRangeLabel.alpha = 0;
    self.startDatePicker.alpha = 0;
    self.startDatePicker.userInteractionEnabled = NO;
    self.endDatePicker.alpha = 0;
    self.endDatePicker.userInteractionEnabled = NO;
}

- (void)styleQueryByDate {
    
    self.originalVids = [self.originalVids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
        return [a.publishedAt compare:b.publishedAt];
    }];
    
    self.videoCountLabel.alpha = 0;
    self.videoCountPicker.alpha = 0;
    self.videoCountPicker.userInteractionEnabled = NO;
    
    self.dateRangeLabel.alpha = 1;
    self.startDatePicker.alpha = 1;
    self.startDatePicker.userInteractionEnabled = YES;
    Video *firstVid = self.originalVids[0];
    self.startDatePicker.date = firstVid.publishedAt;
    self.startDatePicker.minimumDate = self.startDatePicker.date;
    Video *lastVid = self.originalVids[self.originalVids.count-1];
    self.endDatePicker.alpha = 1;
    self.endDatePicker.userInteractionEnabled = YES;
    self.endDatePicker.date = lastVid.publishedAt;
    self.endDatePicker.maximumDate = self.endDatePicker.date;
}

#pragma mark - Video Date Range Pickers

- (IBAction)onChangeStartDate:(id)sender {
    [self updateVids];
}

- (IBAction)onChangeEndDate:(id)sender {
    [self updateVids];
}

- (void)updateVids {
    self.modifiedQueryVids = [NSMutableArray arrayWithArray:self.originalVids];
    double ySum = [APIManager getYSum];
    for (Video* video in self.originalVids) {
        // If the video does not fall in the date range then remove it from modifiedVids
        if (([video.publishedAt compare:self.startDatePicker.date] < 0) || ([video.publishedAt compare:self.endDatePicker.date] > 0)) {
            [self.modifiedQueryVids removeObject:video];
            ySum -= video.views;
        }
    }
    [APIManager setYSum:ySum];
    [self setChart:self.modifiedQueryVids];
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
