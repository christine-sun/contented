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
        cloudView.frame = CGRectMake(0, 0, 150, 100);
        [self addSubview:cloudView];
    }
    return self;
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
    BOOL doesIntersectTrash = CGRectIntersectsRect(trashView.frame, self.frame);
    if (doesIntersectTrash) {
        [self animateTrash];
    } else {
        [trashView.layer removeAllAnimations];
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
    
    // If new point intersects trashcan then delete on backend
//    CGRect boundsA = [trashView convertRect:trashView.bounds toView:nil];
//    CGRect boundsB = [self convertRect:self.bounds toView:nil];
//    Boolean viewsOverlap = CGRectIntersectsRect(boundsA, boundsB);
    BOOL methodB = CGRectIntersectsRect(trashView.frame, self.frame);
    NSLog(@"here %d", methodB);
   
    
    // Update idea's location on backend
    NSString *newLocation = NSStringFromCGPoint(newPoint);
    PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
    [query getObjectInBackgroundWithId:self.idea.objectId block:^(PFObject * _Nullable idea, NSError * _Nullable error) {
        idea[@"location"] = newLocation;
        [idea saveInBackground];
    }];
    
}

@end
