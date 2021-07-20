//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"
#import "Video.h"

@implementation APIManager

NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8";

+ (NSDictionary*) fetchLast20Views {
    // Get the last 20 videos from this user
    NSString *userID = @"UCt7gY0riLR5YJLISl3RK5iw";
    
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
            NSMutableArray *vids = [[NSMutableArray alloc] init];
            NSArray *videos = initialDictionary[@"items"];
            for (int i = 0; i < videos.count; i++) {
                NSDictionary *thisVideo = videos[i];
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
                    [vids addObject:video];
                    
                }
            }
            
            
            for (int i = 0; i < [vids count]; i++) {
                // call the network request to get the number of views for this
                Video *video = vids[i];
                NSString *videoID = video.vidID;
        
                NSString *baseString = @"https://www.googleapis.com/youtube/v3/videos?part=statistics&id=";
                baseString = [baseString stringByAppendingString:videoID];
                baseString = [baseString stringByAppendingString:@"&key="];
                baseString = [baseString stringByAppendingString:API_KEY];
                NSURL *url = [NSURL URLWithString:baseString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
                NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (error != nil) {
                            NSLog(@"%@", [error localizedDescription]);
                        }
                        else {
                            NSDictionary *videoDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            NSArray *items = videoDict[@"items"];
                            NSDictionary *middle = items[0];
                            NSDictionary *stats = middle[@"statistics"];
                            NSString *viewCount = stats[@"viewCount"];
                            video.views = [viewCount integerValue];
                            NSLog(@"%@ %@ %d", video.title, video.publishedAt, video.views);
                        }
                }];
                [task resume];
            }
        }
    }];
    [task resume];
    return 0;
}

@end
