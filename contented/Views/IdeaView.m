//
//  IdeaView.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "IdeaView.h"

@implementation IdeaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

UIImageView *trashView;

- (void)setTrashView:trash {
    trashView = trash;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *cloudView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"cloud.fill"]];
        [cloudView setTintColor:[UIColor systemTealColor]];
//        [cloudView setTintColor:[self getRandomColor]];
        cloudView.frame = CGRectMake(0, 0, 150, 100);
        [self addSubview:cloudView];
    }
    return self;
}

- (UIColor*) getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:1 alpha:1];
    return color;
}

- (void)setName:(NSString*)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, 100)];
    label.numberOfLines = 3;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (CGRectIntersectsRect(trashView.frame, self.frame)) {
        [self animateTrash];
        self.alpha = 0.7;
    } else {
        [trashView.layer removeAllAnimations];
        self.alpha = 1;
    }
}

- (void)animateTrash {
    trashView.transform = CGAffineTransformMakeRotation(-.1);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        trashView.transform = CGAffineTransformMakeRotation(.1);
    } completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint newPoint = [[touches anyObject] locationInView:self.superview];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
    [query getObjectInBackgroundWithId:self.idea.objectId block:^(PFObject * _Nullable idea, NSError * _Nullable error) {
        // If new point intersects trashcan then delete on backend
        if (CGRectIntersectsRect(trashView.frame, self.frame)) {
            [self removeFromSuperview];
            [idea deleteInBackground];
        }
        // Update idea's location on backend
        else {
            NSString *newLocation = NSStringFromCGPoint(newPoint);
            idea[@"location"] = newLocation;
            [idea saveInBackground];
        }
    }];
    trashView.transform = CGAffineTransformMakeRotation(0);
    [trashView.layer removeAllAnimations];
}

@end
