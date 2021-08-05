//
//  Video.m
//  contented
//
//  Created by Christine Sun on 7/20/21.
//

#import "Video.h"

@implementation Video

- (int)getViews:(NSDictionary*) videoDict {
    NSArray *items = videoDict[@"items"];
    NSDictionary *middle = items[0];
    NSDictionary *stats = middle[@"statistics"];
    NSString *viewCount = stats[@"viewCount"];
    return [viewCount integerValue];
}

@end
