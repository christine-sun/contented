//
//  AnalyticsViewController.h
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import <UIKit/UIKit.h>
@import GoogleSignIn;
#import <GTLRYouTube.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRYouTubeService *service;

@end

NS_ASSUME_NONNULL_END
