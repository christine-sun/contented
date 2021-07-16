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
@property (nonatomic) int archived;

+ (void) postTask: (NSString*) title
    withDescription: (NSString* _Nullable) ideaDump
    withDate: (NSDate*) date
    withImage:  (UIImage* _Nullable) image
    withPlatforms: (NSDictionary*) platforms
    ofType: (NSString*) type
    withCompletion: (PFBooleanResultBlock _Nullable) completion;

+ (PFFileObject*) getPFFileFromImage: (UIImage* _Nullable) image;

@end

NS_ASSUME_NONNULL_END
