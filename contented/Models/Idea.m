//
//  Idea.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "Idea.h"
#import "IdeaView.h"

@implementation Idea

@dynamic title;
@dynamic details;
@dynamic location;

+ (nonnull NSString*) parseClassName {
    return @"Idea";
}

+ (void) postIdea: (NSString*) title withCompletion: (PFBooleanResultBlock _Nullable) completion {
    Idea *idea = [Idea new];
    idea.title = title;
//    idea.location = CGPointMake(0, 0);
    idea.location = NSStringFromCGPoint(CGPointMake(150, 150));
    idea.user = [PFUser currentUser];
    
    [idea saveInBackgroundWithBlock:completion];
    
    // add this idea to current user's ideas
//    NSMutableArray *userIdeas = idea.user[@"ideas"];
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *userIdeas = currentUser[@"ideas"];
    if (userIdeas == nil) {
        userIdeas = [[NSMutableArray alloc] init];
    }
    NSLog(@"this users array looks like %@", userIdeas);
    
    // create an Idea View
//    IdeaView *ideaView = [[IdeaView alloc] init];
//    ideaView.idea = idea;
//    [userIdeas addObject:ideaView];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
//    NSLog(@"%@", currentUser.objectId);
//    PFObject *test = [query getObjectWithId:currentUser.objectId];
//    NSLog(@"test %@", test);
//    [query getObjectInBackgroundWithId:currentUser.objectId block:^(PFObject *user, NSError *error) {
//        user[@"ideas"] = userIdeas;
//        if (error) NSLog(@"WAAAA");
//        [user saveInBackground];
//    }];
//    idea.user[@"ideas"] = userIdeas;
//    [idea.user saveInBackgroundWithBlock:nil];
//    currentUser[@"ideas"] = userIdeas;
//    [currentUser saveInBackgroundWithBlock:nil];
    
}

@end
