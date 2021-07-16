//
//  Task.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "Task.h"

@implementation Task

@dynamic title;
@dynamic ideaDump;
@dynamic dueDate;
@dynamic platforms;
@dynamic type;
@dynamic user;
@dynamic image;

+ (nonnull NSString*) parseClassName {
    return @"Task";
}

+ (void) postTask: (NSString*) title
    withDescription: (NSString* _Nullable) ideaDump
    withDate: (NSDate*) date
    withImage: (UIImage* _Nullable) image
    withPlatforms: (NSDictionary*) platforms
    ofType: (NSString*) type
    withCompletion: (PFBooleanResultBlock _Nullable) completion {
    
    Task *task = [Task new];
    task.title = title;
    task.ideaDump = ideaDump;
    task.dueDate = date; 
    task.image = [self getPFFileFromImage:image];
    task.user = [PFUser currentUser];
    task.platforms = platforms;
    task.type = type;
    task.archived = 0;

    [task saveInBackgroundWithBlock:completion];
    
}

+ (PFFileObject*) getPFFileFromImage: (UIImage* _Nullable) image {
    if (!image) return nil;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) return nil;
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
