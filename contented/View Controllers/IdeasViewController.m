//
//  IdeasViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "IdeasViewController.h"
#import "Idea.h"
#import "UIView+draggable.h"

@interface IdeasViewController ()

@property (strong, nonatomic) UIImageView *trashView;

@end

@implementation IdeasViewController

CGPoint ideaOriginalCenter;
IdeaView *currentView;
BOOL trashIsShowingPendingDropAppearance;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Clear the VC
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    self.trashView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"trash"]];
    self.trashView.frame = CGRectMake(10, 100, 30, 30);
    [self.view addSubview:self.trashView];
    
    [self loadIdeaViews];

}

- (void)loadIdeaViews {
    // Fetch all ideas from this user
    PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    NSArray *ideas = [query findObjects];
    
    // Put ideas into ideaViews
    for (int i = 0; i < ideas.count; i++) {
        IdeaView *ideaView = [[IdeaView alloc] init];
        ideaView.idea = ideas[i];
        [ideaView setName:ideaView.idea.title];
        
        // Set idea location to be where it was last saved
        Idea *idea = [query getObjectWithId:ideaView.idea.objectId];
        NSString *ideaStringLocation = idea[@"location"];
        NSString *prefix = @"{";
        NSString *suffix = @"}";
        NSRange coordsRange = NSMakeRange(prefix.length, ideaStringLocation.length - prefix.length - suffix.length);
        NSString *coords = [ideaStringLocation substringWithRange:coordsRange];
        NSArray *coordsArray = [coords componentsSeparatedByString:@", "];
        NSInteger x = [coordsArray[0] integerValue];
        NSInteger y = [coordsArray[1] integerValue];
        ideaView.frame = CGRectMake(x - 50, y - 50, 150, 100);
        
        
        // test begin
        [ideaView setTrashView:self.trashView];
        // test end
        
        [ideaView enableDragging];
        [self.view addSubview:ideaView];
        
        currentView = ideaView;
        NSLog(@"%@", currentView.idea.title);
    }
}

- (IBAction)onTapAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"new idea☁️" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
        style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"add✨" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
        
        [Idea postIdea:alert.textFields.firstObject.text withCompletion:nil];
        [self loadIdeaViews];
    }];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)labelWasDragged:(UIPanGestureRecognizer *)recognizer {
    ideaOriginalCenter = currentView.center;
    [self moveLabelForDrag:recognizer];

    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self labelDragDidChange:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self labelDragDidEnd:recognizer];
            break;
        case UIGestureRecognizerStateCancelled:
            [self labelDragDidAbort:recognizer];
            break;
        default:
            break;
    }
}

- (void)moveLabelForDrag:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:currentView];
    [sender setTranslation:CGPointZero inView:currentView];
    CGPoint center = currentView.center;
    center.x += translation.x;
    center.y += translation.y;
    currentView.center = center;
}

- (void)labelDragDidChange:(UIPanGestureRecognizer *)recognizer {
    if ([self dragIsOverTrash:recognizer]) {
        [self updateTrashAppearanceForPendingDrop];
    } else {
        [self updateTrashAppearanceForNoPendingDrop];
    }
}

- (void)labelDragDidEnd:(UIPanGestureRecognizer *)recognizer {
    if ([self dragIsOverTrash:recognizer]) {
        [self dropLabelInTrash];
    } else {
        [self abortLabelDrag];
    }
}

- (void)labelDragDidAbort:(UIPanGestureRecognizer *)recognizer {
    [self abortLabelDrag];
}

- (BOOL)dragIsOverTrash:(UIPanGestureRecognizer *)recognizer {
    CGPoint pointInTrash = [recognizer locationInView:self.trashView];
    return [self.trashView pointInside:pointInTrash withEvent:nil];
}

- (void)updateTrashAppearanceForPendingDrop {
    if (trashIsShowingPendingDropAppearance)
        return;
    trashIsShowingPendingDropAppearance = YES;
    self.trashView.transform = CGAffineTransformMakeRotation(-.1);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.trashView.transform = CGAffineTransformMakeRotation(.1);
    } completion:nil];
}

- (void)updateTrashAppearanceForNoPendingDrop {
    if (!trashIsShowingPendingDropAppearance)
        return;
    trashIsShowingPendingDropAppearance = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.trashView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dropLabelInTrash {
    [self updateTrashAppearanceForNoPendingDrop];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        currentView.center = self.trashView.center;
        currentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [currentView removeFromSuperview];
        currentView = nil;
    }];
}

- (void)abortLabelDrag {
    [self updateTrashAppearanceForNoPendingDrop];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        currentView.center = ideaOriginalCenter;
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
