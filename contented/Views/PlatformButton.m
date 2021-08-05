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

-(void) setup: (NSString*) title: (int) state: (UIColor*) color {
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.heightAnchor constraintEqualToConstant:60].active = YES;
    [self.layer setCornerRadius:10];
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = color.CGColor;
    if (state == 0) {
        // Colored title white background
        [self setTitleColor:color forState:UIControlStateNormal];
    } else {
        // White title colored background
        self.backgroundColor = color;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
