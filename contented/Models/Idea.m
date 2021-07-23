//
//  Idea.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "Idea.h"

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
    idea.location = CGPointMake(0, 0);
    idea.user = [PFUser currentUser];
    
    [idea saveInBackgroundWithBlock:completion];
    
    // add this idea to current user's ideas
    NSMutableArray *userIdeas = idea.user[@"ideas"];
    if (userIdeas == nil) {
        userIdeas = [[NSMutableArray alloc] init];
    }
    [userIdeas addObject:idea];
    idea.user[@"ideas"] = userIdeas;
    [idea.user saveInBackgroundWithBlock:nil];
}

@end
