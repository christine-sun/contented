//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"
#import "Video.h"
#import <Parse/Parse.h>

@interface APIManager () <IChartAxisValueFormatter>

@end

@implementation APIManager

NSMutableArray *vids;
//NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8"; // should hide
NSString *API_KEY = @"AIzaSyBCt43tUqtpzLpgnAQ6u2Q9ft35_hcwx24";
LineChartView *lineChartView;
double ySum;
UILabel *ytLabel;
CGFloat maxViews;
NSString *maxViewTitle = @"";
UILabel *recLabel;
int totalVidsCount;
UIDatePicker *startDatePicker;
UIDatePicker *endDatePicker;
AnalyticsViewController *analyticsVC;

+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel {
    ytLabel = ytReportLabel;
}

+ (void)setAnalyticsVC:(AnalyticsViewController*)analyticsViewController {
    analyticsVC = analyticsViewController;
}

+ (NSMutableArray*) getVids {
    return vids;
}

+ (void) setVids: (NSMutableArray*) videos {
    vids = videos;
}

+ (double) getYSum {
    return ySum;
}

+ (void) setYSum: (double)newYSum {
    ySum = newYSum;
}

+ (void)setRecommendationLabel:(UILabel*)recommendationLabel {
    recLabel = recommendationLabel;
}

+ (void)setDatePickers:(UIDatePicker*)start end:(UIDatePicker*)end {
    startDatePicker = start;
    endDatePicker = end;
}

+ (NSDictionary*) fetchRecentViews: (NSString*) userID withVideoCount: (NSString*) vidCount {
        
    vids = [[NSMutableArray alloc] init];
    // Get the last 20 videos from this user
    NSString *baseString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?key=%@&channelId=%@&part=snippet,id&order=date&maxResults=%@", API_KEY, userID, vidCount];
    
    __block NSDictionary *initialDictionary = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:baseString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            initialDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *videos = initialDictionary[@"items"];
            totalVidsCount = videos.count;
            ySum = 0;
            maxViews = LONG_MIN;
            for (int i = 0; i < videos.count; i++) {
                [self setVideoProperties:videos[i]];
            }
        }
    }];
    [task resume];
    return 0;
}

// Set the title and video ID of this video
+ (void)setVideoProperties: (NSDictionary*)thisVideo {
    NSDictionary *ids = thisVideo[@"id"];
    NSString *videoId = ids[@"videoId"];
    if (videoId != nil) {
        Video *video = [[Video alloc] init];
        NSDictionary *snippet = thisVideo[@"snippet"];
        NSString *title = snippet[@"title"];
        NSString *published = snippet[@"publishedAt"];
        video.title = title;
        video.vidID = videoId;
        video.publishedAt = [self stringToDate:published];
        
        NSString *baseString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=statistics&id=%@&key=%@", videoId, API_KEY];
        NSURL *url = [NSURL URLWithString:baseString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                else {
                    NSDictionary *videoDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self setVideoViews:video:videoDict];
                    [self setChartValues];
                    
                    Video *firstVideo = vids[0];
                    startDatePicker.date = firstVideo.publishedAt;
                    startDatePicker.minimumDate = startDatePicker.date;
                    
                    Video *lastVideo = vids[vids.count - 1];
                    endDatePicker.date = lastVideo.publishedAt;
                    endDatePicker.maximumDate = endDatePicker.date;
                }
                // Save array of videos in the analytics VC
                if (vids.count == totalVidsCount && [self allViewsHaveBeenSet]) {
                    [analyticsVC setOriginalVideos:vids];
                }
        }];
        [task resume];

        [vids addObject:video];
    
    }
}

+ (BOOL) allViewsHaveBeenSet {
    for (Video* video in vids) {
        if (video.views == 0) return false;
    }
    return true;
}

// Create a dictionary representation of a video object to save to backend/JSON
+ (NSMutableDictionary*)vidToDict:(Video*)video{
    NSMutableDictionary *videoDict = [[NSMutableDictionary alloc] init];
    [videoDict setValue:video.title forKey:@"title"];
    [videoDict setValue:video.vidID forKey:@"vidID"];
    [videoDict setValue:[NSNumber numberWithInteger:video.views] forKey:@"views"];
    [videoDict setValue:video.publishedAt forKey:@"publishedAt"];
    return videoDict;
}

// Get the view count of this video and set its view property
+ (void)setVideoViews:(Video*)video: (NSDictionary*)videoDict {
    NSArray *items = videoDict[@"items"];
    NSDictionary *middle = items[0];
    NSDictionary *stats = middle[@"statistics"];
    NSString *viewCount = stats[@"viewCount"];
    video.views = [viewCount integerValue];
    ySum += video.views;
    if (video.views > maxViews) {
        maxViews = video.views;
        maxViewTitle = video.title;
    }
}

+ (void)setChart: (LineChartView*) otherLineChartView {
    lineChartView = otherLineChartView;
}

+ (void)setChartValues {
//    [self setMaxViewedVideo];
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//    double xSum = 0;
//    for (int i = 0; i < vids.count; i++) {
//        xSum += i;
//    }
//    double xMean = xSum / vids.count;
//    double yMean = ySum / vids.count;
//    double numerator = 0; // find numerator in least squares equation
//    double denominator = 0; // find denominator in least squares equation
    
//    // Sort vids such that the video dates are in ascending order
//    vids = [vids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
//        return [a.publishedAt compare:b.publishedAt];
//    }];
    
//    for (int i = 0; i < vids.count; i++) {
//        Video *video = vids[i];
//        [values addObject:[[ChartDataEntry alloc] initWithX:i y:video.views]];
//        numerator += ((i - xMean) * (video.views - yMean));
//        denominator += ((i - xMean)*(i - xMean));
//    }
 
//    [analyticsVC setOriginalVals:vids];
    
//    double slope = numerator / denominator;
//    if (slope < -50) {
//        [ytLabel setText:@"Consider what types of videos did well for your channel in the past - are there ways to rekindle that creativity and inspiration?"];
//    }
//    else if (slope > 50) {
//        [ytLabel setText:@"Wow, you have been doing amazing! Keep on pushing out creative content 🔥"];
//    }
//    else {
//        [ytLabel setText:@"Your views have been consistent! Consider bringing in new ideas to your channel to reach a new audience :)"];
//    }
    
    [analyticsVC setChart:vids];
    
//    recLabel.text = [NSString stringWithFormat:@"Your best performing video in this time period was %@🔥\nLet's think together... 🤔\n 😲 What was special about this video?\n ☁️ What are some other videos you can make that follow the captivating themes of this one?", maxViewTitle];
}

//+ (void)setMaxViewedVideo {
//    maxViews = LONG_MIN;
//    maxViewTitle = @"";
//    for (Video *video in vids) {
//        if (video.views > maxViews) {
//            maxViews = video.views;
//            maxViewTitle = video.title;
//        }
//    }
//}

+ (NSDate*) stringToDate:(NSString*) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:dateString];
}

+ (void) setProfileImage: (NSString*) userID forImageView: (UIImageView*) imageView {
    NSString *baseString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=snippet&id=%@&fields=items%%2Fsnippet%%2Fthumbnails&key=%@", userID, API_KEY];
    __block NSDictionary *initialDictionary = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:baseString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            initialDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *videos = initialDictionary[@"items"];
            NSString *profilePicLink = videos[0][@"snippet"][@"thumbnails"][@"medium"][@"url"];
            NSURL *profilePicURL = [NSURL URLWithString:profilePicLink];
            NSData *data = [NSData dataWithContentsOfURL:profilePicURL];
            UIImage *img = [[UIImage alloc] initWithData:data];
            [imageView setImage:img];
        }
    }];
    [task resume];
}

@end
