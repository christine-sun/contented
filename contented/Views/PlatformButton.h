//
//  PlatformButton.h
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformButton : UIButton

-(void) setupWithTitleAndState: (NSString*) title: (int)state;
-(void)onTap;

@end

NS_ASSUME_NONNULL_END
