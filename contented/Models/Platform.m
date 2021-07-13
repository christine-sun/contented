//
//  Platform.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "Platform.h"

@implementation Platform

@dynamic type;
@dynamic userID;
@dynamic initialFollowing;

+ (nonnull NSString*) parseClassName {
    return @"Platform";
}

@end
