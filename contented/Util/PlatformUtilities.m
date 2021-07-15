//
//  PlatformUtilities.m
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import "PlatformUtilities.h"

@implementation PlatformUtilities

+ (NSArray*) getPlatformsForType:(NSString*) type {
    if ([type isEqualToString:@"long"]) {
        return @[@"YouTube", @"Instagram"];
    } else if ([type isEqualToString:@"short"]) {
        return @[@"YouTube", @"Instagram", @"TikTok"];
    } else {
        return @[@"YouTube", @"Instagram", @"Snapchat", @"Twitter"];
    }
}

@end
