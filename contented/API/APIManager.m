//
//  APIManager.m
//  contented
//
//  Created by Christine Sun on 7/19/21.
//

#import "APIManager.h"

@implementation APIManager

NSString* API_KEY = @"AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8";

+ (NSArray*) fetchLast20Videos: (NSString*) userID {
    NSMutableArray* videoIDs = [[NSMutableArray alloc] init];
    // get last 20 videos from this user
    // https://www.googleapis.com/youtube/v3/search?key=AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&part=snippet,id&order=date&maxResults=20
    NSString *baseString = @"https://www.googleapis.com/youtube/v3/search?key=";
    baseString = [baseString stringByAppendingString:API_KEY];
    baseString = [baseString stringByAppendingString:@"&channelId="];
    baseString = [baseString stringByAppendingString:userID];
    baseString = [baseString stringByAppendingString:@"&part=snippet,id&order=date&maxResults=20"];
    NSLog(@"%@", baseString);
//    [self fetchInitialDictionary:@""];
    
    
    return 0;
}

+ (NSNumber*) fetchViewCount: (NSString*) videoID {
// // get view count from a video getting ID from ^ https://www.googleapis.com/youtube/v3/videos?part=statistics&id=qDlMQjPmPE0&key=AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8
    
    return 0;
}

+ (NSNumber*) fetchSubCount: (NSString*) userID {
// get user subscriber count https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=UC_x5XG1OV2P6uZZ5FSM9Ttw&key=AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8
    
    return 0;
}

+ (NSDictionary*) fetchInitialDictionary: (NSString*) URL {
    __block NSDictionary *dict = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
    }];
    [task resume];
    
    return dict;
}

@end
