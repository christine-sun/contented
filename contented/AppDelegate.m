//
//  AppDelegate.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Task.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Connect to Parse client
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = @"J8Mr5xZqUC8Ab4ER9DVi6BBydc5xx2BtzQLwvJ0C";
        configuration.clientKey = @"J2uv81vBkFwSL3jlf9BH8WoOXGb5PHosRr1IJmc3";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    
    // Test that task model works - YES works
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(TRUE), @"youtube", @(FALSE), @"instagram", nil];
//    [Task postTask:@"test title" withDescription:@"I am testing to see if the task model works" withImage:nil withPlatforms:dict ofType:@"long" withCompletion:nil];
    
//    // Add columns to user model - come back after implementing log in
//    PFUser *user = [PFUser currentUser];
//    user[@"initialSubs"] = @135;
//    user[@"youtubeID"] = @"UClskd48fj49ljfHA";
//
//    NSMutableArray *tasks = [NSMutableArray arrayWithObjects:@"Task1", @"Task2", @"Task3", nil];
//    user[@"tasks"] = tasks;
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//      if (succeeded) {
//             NSLog(@"Object saved!");
//      } else {
//          NSLog(@"Error: %@", error.description);
//      }
//    }];

    
    
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
