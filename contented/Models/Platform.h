//
//  Platform.h
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "PFObject.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Platform : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) CGFloat initialFollowing;

@end

NS_ASSUME_NONNULL_END
