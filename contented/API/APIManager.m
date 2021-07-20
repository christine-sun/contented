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

NSDictionary *dict;
NSMutableArray *videos;
int thisIndex;

//
NSDictionary *initialDictionary;
int first;

//
+ (void) fetchInitialDictionary {
    first = 0;
    // pass in URL
    initialDictionary = [[NSDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/search?key=AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&part=snippet,id&order=date&maxResults=20"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSLog(@"in here");
            initialDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            first = 1;
        }
        
    }];
    [task resume];
    
    while (first == 0) {
        NSLog(@"wait");
    }
//    
//    while (initialDictionary.count == 0) {
//        // wait
////        NSLog(@"wait");
//    }
    
    NSArray *items = dict[@"items"];
    NSLog(@"items %@", items);
    for (int i = 0; i < items.count; i++) {
        NSDictionary *thisVideo = items[i];
        NSDictionary *ids = thisVideo[@"id"];
        NSString *videoId = ids[@"videoId"];
        if (videoId != nil) {
            Video *video = [[Video alloc] init];
            NSDictionary *snippet = thisVideo[@"snippet"];
            NSString *title = snippet[@"title"];
            video.title = title;
            video.vidID = videoId;
            // a method that finds the video ID's views
//            int views = [self fetchViewsForID:videoId];
//            video.views = views;
            [videos addObject:video];
            
        }
    }
}

// now, initialDict contains the dictionary of videos

+ (NSArray*) fetchLast20Videos: (NSString*) userID {
    NSMutableArray* videoIDs = [[NSMutableArray alloc] init];
    // get last 20 videos from this user
    // https://www.googleapis.com/youtube/v3/search?key=AIzaSyDqMCcWcGl3kQdFPI-CskwwFcm0N4CsU-8&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&part=snippet,id&order=date&maxResults=20
    NSString *baseString = @"https://www.googleapis.com/youtube/v3/search?key=";
    baseString = [baseString stringByAppendingString:API_KEY];
    baseString = [baseString stringByAppendingString:@"&channelId="];
    baseString = [baseString stringByAppendingString:userID];
    baseString = [baseString stringByAppendingString:@"&part=snippet,id&order=date&maxResults=20"];
    // possibly make a numOfVids int that you append after the =
//    NSLog(@"reached here");
    
    
//    [self fetchInitialDictionary:baseString];
//    NSLog(@"3");
//    dispatch_sync([NSThread isMainThread], [self fetchInitialDictionary:baseString]);
    
    NSDictionary *dict = initialDictionary;
//    NSLog(@"2 %@", initialDictionary);
//    NSLog(@"%@", dict);
    NSArray *videos = dict[@"items"];
    for (int i = 0; i < videos.count; i++) {
//        NSLog(@"reached %d", i);
        NSDictionary *thisVideo = videos[i];
        NSDictionary *ids = thisVideo[@"id"];
        NSString *videoId = ids[@"videoId"];
//        NSLog(@"%@", videoId);
    }
    
    // iterate through videos
    
    
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



+ (NSDictionary*) fetchLast20Views {
    // Get the last 20 videos from this user
    NSMutableArray* videoIDs = [[NSMutableArray alloc] init];
    NSString *userID = @"UCt7gY0riLR5YJLISl3RK5iw";
    NSString *baseString = @"https://www.googleapis.com/youtube/v3/search?key=";
    baseString = [baseString stringByAppendingString:API_KEY];
    baseString = [baseString stringByAppendingString:@"&channelId="];
    baseString = [baseString stringByAppendingString:userID];
    baseString = [baseString stringByAppendingString:@"&part=snippet,id&order=date&maxResults=20"];
    
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
            
            NSMutableArray *views = [[NSMutableArray alloc] init];
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            NSMutableArray* videoIDs = [[NSMutableArray alloc] init];
            NSArray *videos = initialDictionary[@"items"];
//            NSLog(@"videos %@", videos);
            for (int i = 0; i < videos.count; i++) {
//                NSLog(@"reached %d", i);
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
                    
//                    [videoIDs addObject:videoId];
//                    NSMutableArray *vidInfo = [[NSMutableArray alloc] init];
//                    NSDictionary *snippet = thisVideo[@"snippet"];
//                    NSString *title = snippet[@"title"];
//                    [titles addObject:title];
//                    NSLog(@"%@", title);
                }
            }
//            NSLog(@"%@", titles);
//            NSLog(@"%@", videoIDs);
            // AT THIS POINT, WE HAVE FETCHED THE LAST 20 VIDEOS AND STORED their IDs and titles into vids
            
            
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
//                            NSLog(@"00000000000 %@", items);
                            NSDictionary *middle = items[0];
//                            NSLog(@"11111111111 %@", middle);
                            NSDictionary *stats = middle[@"statistics"];
                            NSString *viewCount = stats[@"viewCount"];
                            video.views = [viewCount integerValue];
                            NSLog(@"%@ %@ %d", video.title, video.publishedAt, video.views);
//                            [result setValue:arr forKey:videoID];
//                            [views addObject:viewCount];
                        }
                    
                    
                }];
                [task resume];
                
            }
//
//            for (int i = 0; i < [vids count]; i++) {
//                Video *video = vids[i];
//                NSLog(@"TITLE: %@ ", video.title);
//                NSLog(@"VID ID: %@ ", video.vidID);
//                NSLog(@"VIEWS: %d ", video.views);
//            }
//
            
            
        }
        
        
        
    }];
    [task resume];
    return 0;
}

+ (NSString*) get20VidsURL : (NSString*) userID {
    NSString *baseString = @"https://www.googleapis.com/youtube/v3/search?key=";
    baseString = [baseString stringByAppendingString:API_KEY];
    baseString = [baseString stringByAppendingString:@"&channelId="];
    baseString = [baseString stringByAppendingString:userID];
    baseString = [baseString stringByAppendingString:@"&part=snippet,id&order=date&maxResults=20"];
    return baseString;
}

+ (NSDictionary*) testLast20Views {
    // TESTING NSNOTIFICATIONS
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getViews:) name:@"gotVids" object:nil];
    NSString *userID = @"UCt7gY0riLR5YJLISl3RK5iw"; // prob pass in

    // Fetch the last 20 videos
//    NSMutableArray *videos = [[NSMutableArray alloc] init];
    NSString *vidsURL = [APIManager get20VidsURL:userID];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotVidsDictionary:) name:@"gotDict" object:nil];
    [self fetchInitDictionary:vidsURL:0];
//    NSLog(@"UP THERE %@", videos);
//    dict = [self gotVidsDictionary:nil];
    
    // now dict should be updated to have the big dict from the API call
    // WAITTT for the above to finish before moving on
    // extract the title and vidID from each
//    NSArray *items = dict[@"items"];
//    for (int i = 0; i < videos.count; i++) {
//        NSDictionary *thisVideo = items[i];
//        NSDictionary *ids = thisVideo[@"id"];
//        NSString *videoId = ids[@"videoId"];
//        if (videoId != nil) {
//            Video *video = [[Video alloc] init];
//            NSDictionary *snippet = thisVideo[@"snippet"];
//            NSString *title = snippet[@"title"];
//            video.title = title;
//            video.vidID = videoId;
//            // a method that finds the video ID's views
//            int views = [self fetchViewsForID:videoId];
//            video.views = views;
//            [videos addObject:video];
//
//        }
//    }
    
    // now, videos contains an array of video objects, and their title and VidID. however, now it's time to go through them again and add the VIEWS to each video. we can prob do this WHILE we are iterating through ^^
    // see if it worked
//    for (int i = 0; i < [videos count]; i++) {
//        Video *video = videos[i];
//        NSLog(@"title %@ ", video.title);
//        NSLog(@"id %@ ", video.vidID);
//        NSLog(@"views %@ ", video.views);
//    }
    return 0;
//    __block NSDictionary *initialDictionary = [[NSDictionary alloc] init];
//    NSURL *url = [NSURL URLWithString:[self get20VidsURL:userID]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        if (error != nil) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        else {
//            initialDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSMutableArray *vids = [[NSMutableArray alloc] init];
//            NSArray *videos = initialDictionary[@"items"];
//            for (int i = 0; i < videos.count; i++) {
//                NSDictionary *thisVideo = videos[i];
//                NSDictionary *ids = thisVideo[@"id"];
//                NSString *videoId = ids[@"videoId"];
//                if (videoId != nil) {
//                    Video *video = [[Video alloc] init];
//                    NSDictionary *snippet = thisVideo[@"snippet"];
//                    NSString *title = snippet[@"title"];
//                    video.title = title;
//                    video.vidID = videoId;
//                    [vids addObject:video];
//                }
//            }
//            NSLog(@"111 finished getting vids");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotVids" object:self];
//
//        }
//    }];
//    [task resume];
//    return 0;
}

+ (void)fetchInitDictionary : (NSString*) URL : (int) state {
    dict = [[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotVidsDictionary:) name:@"gotDict" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotViewsDictionary) name:@"gotViews" object:nil];
    
    NSURL *url = [NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"we have set the dict");
            if (state == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotDict" object:self];
            } else if (state == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotViews" object:self];
            }
        }
    }];
    [task resume];
    
}
//
//- (void) dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
//}

+ (NSDictionary*)gotVidsDictionary:(NSNotification *)notif {
    videos = [[NSMutableArray alloc] init];

    // now dict is right
    NSArray *items = dict[@"items"];
    NSLog(@"items %@", items);
    for (int i = 0; i < items.count; i++) {
        NSDictionary *thisVideo = items[i];
        NSDictionary *ids = thisVideo[@"id"];
        NSString *videoId = ids[@"videoId"];
        if (videoId != nil) {
            Video *video = [[Video alloc] init];
            NSDictionary *snippet = thisVideo[@"snippet"];
            NSString *title = snippet[@"title"];
            video.title = title;
            video.vidID = videoId;
            // a method that finds the video ID's views
//            int views = [self fetchViewsForID:videoId];
//            video.views = views;
            [videos addObject:video];
            
        }
    }
    
    NSLog(@"vdz %@", videos);
    // now videos properly contains all of the videos - we have to find the views now
//    call another method
    [self fetch20Views];
    return dict;
}

+(void)fetch20Views {
    //now videos is proper
    for (int i = 0; i < [videos count]; i++) {
        Video *video = videos[i];
        NSString *vidID = video.vidID;
        thisIndex = i;
        int views = [self fetchViewsForID:vidID];
    }
}

+(void)gotViewsDictionary {
    // now dict is right to be the video's dict
    NSArray *items = dict[@"items"];
    NSDictionary *middle = items[0];
    NSDictionary *stats = middle[@"statistics"];
    NSString *viewCount = stats[@"viewCount"];
    Video *video = videos[thisIndex];
    video.views = [viewCount integerValue];
    NSLog(@"video title %@ and views %d", video.title, video.views);
    
}

+ (int)fetchViewsForID: (NSString*) vidID {
    [self fetchInitDictionary:[self getViewsURL:vidID]:1];
//    NSArray *items = dict[@"items"];
//    NSDictionary *middle = items[0];
//    NSDictionary *stats = middle[@"statistics"];
//    NSString *viewCount = stats[@"viewCount"];
    return 0;
    
}

+ (NSString*) getViewsURL : (NSString*) vidID {
    NSString *baseString = @"https://www.googleapis.com/youtube/v3/videos?part=statistics&id=";
    baseString = [baseString stringByAppendingString:vidID];
    baseString = [baseString stringByAppendingString:@"&key="];
    baseString = [baseString stringByAppendingString:API_KEY];
    return baseString;
}

+ (void)getViews:(NSNotification *)note {
    if([[note name] isEqualToString:@"gotVids"])
        NSLog(@"now I am here");
}



@end
