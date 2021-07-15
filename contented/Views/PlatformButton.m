//
//  PlatformButton.m
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import "PlatformButton.h"

@implementation PlatformButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setupWithTitleAndState: (NSString*) title: (int)state {
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.heightAnchor constraintEqualToConstant:60].active = YES;
    [self.layer setCornerRadius:10];
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor systemTealColor].CGColor;
    if (state == 0) {
        // Blue title white background
        [self setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
    } else {
        // White title blue background
        self.backgroundColor = [UIColor systemTealColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
