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
    idea.location = NSStringFromCGPoint(CGPointMake(150, 150));
    idea.user = [PFUser currentUser];
    
    [idea saveInBackgroundWithBlock:completion];
}

- (CGRect) getCoords {
    CGFloat offset = 50;
    CGFloat width = 150;
    CGFloat height = 100;
    NSString *ideaStringLocation = self[@"location"];
    NSString *prefix = @"{";
    NSString *suffix = @"}";
    NSRange coordsRange = NSMakeRange(prefix.length, ideaStringLocation.length - prefix.length - suffix.length);
    NSString *coords = [ideaStringLocation substringWithRange:coordsRange];
    NSArray *coordsArray = [coords componentsSeparatedByString:@", "];
    NSInteger x = [coordsArray[0] integerValue];
    NSInteger y = [coordsArray[1] integerValue];
    return CGRectMake(x - offset, y - offset, width, height);
}

@end
