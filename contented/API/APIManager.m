//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"
#import "Video.h"

@implementation APIManager

NSMutableArray *vids;
NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8"; // should hide

+ (NSDictionary*) fetchLast20Views: (NSString*) userID {
   
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
            vids = [[NSMutableArray alloc] init];
            NSArray *videos = initialDictionary[@"items"];
            for (int i = 0; i < videos.count; i++) {
                [self setVideoProperties:videos[i]];
            }
        }
    }];
    [task resume];
    return 0;
}

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
        video.publishedAt = published;
        
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
                    NSLog(@"%@ %@ %lu", video.title, video.publishedAt, video.views);
                }
        }];
        [task resume];
        [vids addObject:video];
    }
}

+ (void)setVideoViews:(Video*)video: (NSDictionary*)videoDict {
    NSArray *items = videoDict[@"items"];
    NSDictionary *middle = items[0];
    NSDictionary *stats = middle[@"statistics"];
    NSString *viewCount = stats[@"viewCount"];
    video.views = [viewCount integerValue];
}

@end
