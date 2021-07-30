//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"
#import "Video.h"

@interface APIManager () <IChartAxisValueFormatter>

@end

@implementation APIManager

NSMutableArray *vids;
NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8"; // should hide
LineChartView *lineChartView;
NSMutableArray *titles;
double ySum;
UILabel *ytLabel;
CGFloat maxViews;
NSString *maxViewTitle = @"";
UILabel *recLabel;
UIDatePicker *startDatePicker;
UIDatePicker *endDatePicker;

+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel {
    ytLabel = ytReportLabel;
}

+ (NSMutableArray*) getVids {
    return vids;
}

+ (void) setVids: (NSMutableArray*) videos {
    vids = videos;
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
        }];
        [task resume];

        [vids addObject:video];
    
    }
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
    [self setMaxViewedVideo];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    double xSum = 0;
    for (int i = 0; i < vids.count; i++) {
        xSum += i;
    }
    double xMean = xSum / vids.count;
    double yMean = ySum / vids.count;
    double numerator = 0; // find numerator in least squares equation
    double denominator = 0; // find denominator in least squares equation
    
    // Sort vids such that the video dates are in ascending order
    vids = [vids sortedArrayUsingComparator:^NSComparisonResult(Video *a, Video *b) {
        return [a.publishedAt compare:b.publishedAt];
    }];
    
    titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < vids.count; i++) {
        Video *video = vids[i];
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:video.views]];
        numerator += ((i - xMean) * (video.views - yMean));
        denominator += ((i - xMean)*(i - xMean));
        
        [titles addObject:video.title];
    }
    
    double slope = numerator / denominator;
    NSLog(@"slope %f", slope);
    if (slope < -50) {
        [ytLabel setText:@"Consider what types of videos did well for your channel in the past - are there ways to rekindle that creativity and inspiration?"];
    }
    else if (slope > 50) {
        [ytLabel setText:@"Wow, you have been doing amazing! Keep on pushing out creative content 🔥"];
    }
    else {
        [ytLabel setText:@"Your views have been consistent! Consider bringing in new ideas to your channel to reach a new audience :)"];
    }
    
    // ACCOUNT IDS YOU CAN TEST
    // + Channel that is doing well UCy3zgWom-5AGypGX_FVTKpg
    // - Channel that is not doing well UCxX9wt5FWQUAAz4UrysqK9A
    // 0 Channel that is more stagnant UC5CMtpogD_P3mOoeiDHD5eQ
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithEntries:values label:@"Views"];
    
    set1.drawCirclesEnabled = YES;
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.redColor];
    set1.lineWidth = 1.0;
    set1.mode = LineChartModeCubicBezier;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = YES;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    lineChartView.data = data;
    lineChartView.xAxis.valueFormatter = [[APIManager alloc] init];
    
    recLabel.text = [NSString stringWithFormat:@"Your best performing video in this time period was %@🔥\nLet's think together... 🤔\n 😲 What was special about this video?\n ☁️ What are some other videos you can make that follow the captivating themes of this one?", maxViewTitle];
}

+ (void)setMaxViewedVideo {
    maxViews = LONG_MIN;
    maxViewTitle = @"";
    for (Video *video in vids) {
        if (video.views > maxViews) {
            maxViews = video.views;
            maxViewTitle = video.title;
        }
    }
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis
{
    NSString *xAxisStringValue = @"";
    int myInt = (int)value;

    if(titles.count > myInt) {
        xAxisStringValue = [titles objectAtIndex:myInt];
    }

    return xAxisStringValue;
}

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
