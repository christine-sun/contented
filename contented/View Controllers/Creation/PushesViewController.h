//
//  PushesViewController.h
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PushesViewControllerDelegate

- (void) didEdit:(NSString*) taskTitle: (NSString*) taskIdeas: (UIImage*) taskImage;

@end

@interface PushesViewController : UIViewController

@property (weak, nonatomic) id <PushesViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *ideaDump;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIImage *taskImage;

@end

NS_ASSUME_NONNULL_END
