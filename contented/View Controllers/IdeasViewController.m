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

@property (strong, nonatomic) NSMutableArray<IdeaView*> *ideaViews;

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
    
    // Fetch all ideas from this user
    PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    NSArray *ideas = [query findObjects];
    if (ideas == nil) {
        self.ideaViews = [[NSMutableArray alloc] init];
    }
    
    self.ideaViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < ideas.count; i++) {
        IdeaView *ideaView = [[IdeaView alloc] init];
        ideaView.idea = ideas[i];
        [self.ideaViews addObject:ideaView];
    }
    
    // iterate through self.ideas and display the idea views on the screen
    for (IdeaView *ideaView in self.ideaViews) {
        ideaView.center = CGPointFromString(ideaView.idea.location);
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
//            Idea *idea = [[Idea alloc] init];
//            idea.title = alert.textFields.firstObject.text;
//            IdeaView *ideaView = [[IdeaView alloc] init];
//            ideaView.idea = idea;
            [Idea postIdea:alert.textFields.firstObject.text withCompletion:nil];
        
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
