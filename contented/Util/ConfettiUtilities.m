//
//  ConfettiUtilities.m
//  contented
//
//  Created by Christine Sun on 8/4/21.
//

#import "ConfettiUtilities.h"

@implementation ConfettiUtilities

CAEmitterLayer *emitterLayer;
UIView *emitterView;
UIView* mainView;
NSString* state;

+ (void) startConfettiForView: (UIView*)view forState: (NSString*) theState {
    mainView = view;
    emitterView = [[UIView alloc] init];
    emitterLayer = [[CAEmitterLayer alloc] init];
    state = theState;
    
    emitterLayer.emitterPosition = CGPointMake(view.frame.size.width / 2, -40);
    emitterLayer.emitterSize = CGSizeMake(view.frame.size.width, 1);
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterCells = [self getEmitterCells];

    [emitterView.layer addSublayer:emitterLayer];
    emitterView.backgroundColor = UIColor.clearColor;
    emitterView.alpha = 0.7;
    [view addSubview:emitterView];
    
    [NSLayoutConstraint activateConstraints:@[
            [emitterView.topAnchor constraintEqualToAnchor:view.topAnchor],
            [emitterView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
            [emitterView.leftAnchor constraintEqualToAnchor:view.leftAnchor],
            [emitterView.rightAnchor constraintEqualToAnchor:view.rightAnchor],
    ]];
    emitterView.translatesAutoresizingMaskIntoConstraints = NO;
}

+ (NSMutableArray<CAEmitterCell*>*)getEmitterCells {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 6; i++) {
        CAEmitterCell *cell = [[CAEmitterCell alloc] init];
        cell.birthRate = 1;
        cell.lifetime = 20;
        cell.velocity = arc4random_uniform(50) + 100;
        cell.scale = 0.005;
        cell.scaleRange = 0.005;
        cell.emissionRange = M_PI/2;
        cell.emissionLatitude = (180 * (M_PI / 180));
        cell.alphaRange = 0.3;
        cell.yAcceleration = arc4random_uniform(10) + 10;
        
        if ([state isEqualToString:@"completed"]) {
            NSString *confetti = [NSString stringWithFormat:@"confetti%d", i];
            cell.contents = (id)[[UIImage imageNamed:confetti] CGImage];
        } else if ([state isEqualToString:@"started"]) {
            cell.contents = (id)[[UIImage imageNamed:@"letsgo"] CGImage];
        }
        [cells addObject:cell];
    }
    
    return cells;
}

+ (void)stopConfetti {
    emitterLayer.birthRate = 0;
    [emitterView setUserInteractionEnabled:NO];
}

@end
