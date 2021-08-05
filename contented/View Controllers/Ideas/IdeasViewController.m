//
//  IdeasViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "IdeasViewController.h"
#import "Idea.h"
#import "UIView+draggable.h"
#import "DesignUtilities.h"

@interface IdeasViewController ()

@property (strong, nonatomic) UIImageView *trashView;

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
        [self createIdeaView:ideas[i]];
    }
}

- (void)createIdeaView:(Idea*) idea {
    IdeaView *ideaView = [[IdeaView alloc] init];
    ideaView.idea = idea;
    [ideaView setName:ideaView.idea.title];
    ideaView.frame = [idea getCoords];
    [ideaView setTrashView:self.trashView];
    [ideaView enableDragging];
    [self.view addSubview:ideaView];
    [DesignUtilities fadeIn:ideaView withDuration:0.8];
}

- (IBAction)onTapAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"new idea☁️" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
        style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"add✨" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [Idea postIdea:alert.textFields.firstObject.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            // Add most recently created idea to view
            PFQuery *query = [PFQuery queryWithClassName:@"Idea"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            [query orderByDescending:@"createdAt"];
            query.limit = 1;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                [self createIdeaView:objects[0]];
            }];
        }];
        
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
