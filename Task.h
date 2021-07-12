//
//  Task.h
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "PFObject.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ideaDump;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDictionary *platforms;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFFileObject *image;

@end

NS_ASSUME_NONNULL_END
