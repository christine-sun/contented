//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"
#import "Video.h"

@interface APIManager () <IChartAxisValueFormatter>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation APIManager

NSMutableArray *vids;
NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8"; // should hide
UILabel *label;
NSString *allText;
LineChartView *lineChartView;
NSMutableArray *titles;
double ySum;
UILabel *ytLabel;

+ (void)setLabel:(UILabel*)otherLabel {
    label = otherLabel;
}

+ (UILabel*)getLabel {
    return label;
}

+ (void)setYouTubeReportLabel:(UILabel*)ytReportLabel {
    ytLabel = ytReportLabel;
}

+ (UILabel*)getYTReportLabel {
    return ytLabel;
}

+ (NSMutableArray*) getVids {
    return vids;
}


+ (NSDictionary*) fetchLast20Views: (NSString*) userID {
    vids = [[NSMutableArray alloc] init];
    allText = @"";
    // Get the last 20 videos from this user
    NSString *baseString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?key=%@&channelId=%@&part=snippet,id&order=date&maxResults=20", API_KEY, userID];
    
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
                    // here video.title, video.vidID, and video.views all have the proper values. this is the endpoint
                    allText = [allText stringByAppendingFormat:@"TITLE: %@ VIEWS: %lu\n", video.title, video.views];
                    [self setChartValues];
                }
            [self getLabel].text = allText;
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
}

+ (void)setChart: (LineChartView*) otherLineChartView {
    lineChartView = otherLineChartView;
}

+ (void)setChartValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    double xSum = 190; // the sum of 0+1+2+3+...19
    double xMean = 190 / 2;
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
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithEntries:values];
    
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

@end
