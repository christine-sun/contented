//
//  Idea.h
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "PFObject.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Idea : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;
@property (nonatomic) CGPoint location;

+ (void) postIdea: (NSString*) title withCompletion: (PFBooleanResultBlock _Nullable) completion;

@end

NS_ASSUME_NONNULL_END
