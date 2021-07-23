//
//  IdeasViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "IdeasViewController.h"
#import "Idea.h"
#import "IdeaView.h"

@interface IdeasViewController ()

@property (strong, nonatomic) NSMutableArray *ideaViews;

@end

@implementation IdeasViewController

IBOutlet IdeaView *currentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Clear the VC
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    self.ideaViews = [PFUser currentUser][@"ideas"];
    if (self.ideaViews == nil) {
        self.ideaViews = [[NSMutableArray alloc] init];
    }
    // for a test im going to put in an idea view
    Idea *idea = [[Idea alloc] init];
    idea.title = @"my first idea";
    idea.location = NSStringFromCGPoint(CGPointMake(300, 300));
    IdeaView *ideaView = [[IdeaView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    ideaView.idea = idea;
    [self.ideaViews addObject:ideaView];
    
//    self.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    // mySmallView.frame = CGRectMake(coord1,coord2,width,height);
    
    // iterate through self.ideas and display the idea views on the screen
    for (IdeaView *ideaView in self.ideaViews) {
        ideaView.center = CGPointFromString(idea.location);
        [self.view addSubview:ideaView];
        [ideaView setName:ideaView.idea.title];
        currentView = ideaView;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    // myview setCenter:touchPoint
    [currentView setCenter:touchPoint];
}

- (IBAction)onTapAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"new idea☁️" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
        style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"add✨" style:UIAlertControllerStyleAlert handler:^(UIAlertAction * _Nonnull action) {
            Idea *idea = [[Idea alloc] init];
            idea.title = alert.textFields.firstObject.text;
            IdeaView *ideaView = [[IdeaView alloc] init];
            ideaView.idea = idea;
            [self.ideaViews addObject:ideaView];
    }];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
