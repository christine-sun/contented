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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *cloudView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"cloud.fill"]];
        [cloudView setTintColor:[UIColor systemTealColor]];
        cloudView.frame = CGRectMake(0, 0, 150, 100);
        [self addSubview:cloudView];
        [self setUserInteractionEnabled:YES];
        [self.superview setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
                [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapped:(UIGestureRecognizer *)gesture {
    NSLog(@"MyView tapped %p", self);
}

- (void)setName:(NSString*)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 100, 100)];
    label.numberOfLines = 3;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIPanGestureRecognizer *ideaGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchIdea:)];
//    [self addGestureRecognizer:ideaGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

- (void)didTouchIdea:(UITapGestureRecognizer*) sender {
    [self.delegate ideaView:self didTap:self.idea];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"began");
    self.startPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint newPoint = [[touches anyObject] locationInView:self.superview];
    newPoint.x -= self.startPoint.x;
    newPoint.y -= self.startPoint.y;
    CGRect frm = [self frame];
    frm.origin = newPoint;
    [self setFrame:frm];
//
//    [self setCenter:newPoint];
    
//    CGPoint touchPoint = [[touches anyObject] locationInView:self];
//    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - self.startPoint.x, self.center.y + touchPoint.y - self.startPoint.y);
//    self.center = newCenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint newPoint = [[touches anyObject] locationInView:self.superview];
    // update idea's location on backend
    NSString *newLocation = NSStringFromCGPoint(newPoint);
    PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
    [query getObjectInBackgroundWithId:self.idea.objectId block:^(PFObject * _Nullable idea, NSError * _Nullable error) {
        idea[@"location"] = newLocation;
        [idea saveInBackground];
    }];
}

@end
