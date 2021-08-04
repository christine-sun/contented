//
//  GuideViewController.h
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuideViewController : UIViewController

// state is 0 if guide VC came from an already logged-in user presenting the VC from the home stream. state is 1 if guide VC came from after signing up the user
@property (nonatomic) int state;

- (void)pageControlTapHandler: (UIPageControl*) sender;

@end

NS_ASSUME_NONNULL_END
