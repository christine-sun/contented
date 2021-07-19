//
//  PlatformButton.h
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformButton : UIButton

-(void) setup: (NSString*) title: (int) state: (UIColor*) color;
-(void)onTap;

@end

NS_ASSUME_NONNULL_END
