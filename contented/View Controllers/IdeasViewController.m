//
//  IdeasViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "IdeasViewController.h"
#import "Idea.h"
//#import "SPUserResizableView.h"
#import "UIView+draggable.h"

//@end

@interface IdeasViewController ()

@property (strong, nonatomic) NSMutableArray<IdeaView*> *ideaViews;

@end

@implementation IdeasViewController

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
    NSLog(@"ideas looks like this %@", ideas);
    
    // Put ideas into ideaViews
    for (int i = 0; i < ideas.count; i++) {
        IdeaView *ideaView = [[IdeaView alloc] init];
        ideaView.idea = ideas[i];
        [ideaView setName:ideaView.idea.title];
        ideaView.frame = CGRectMake(100, 100, 150, 100);
        [ideaView enableDragging];
        [self.view addSubview:ideaView];
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
