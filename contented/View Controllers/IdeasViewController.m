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
@property (nonatomic, retain) IBOutlet IdeaView *currentView;

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
//        CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        ideaView.frame = CGRectMake(100, 100, 150, 100);
        ideaView.backgroundColor = [UIColor redColor];
        [ideaView enableDragging];
//        ideaView.center = CGPointFromString(ideaView.idea.location);
        [self.view addSubview:ideaView];
    }
    
    // iterate through self.ideaViews and display the idea views on the screen
//    for (IdeaView *ideaView in self.ideaViews) {
//        ideaView.center = CGPointFromString(ideaView.idea.location);
//        [self.view addSubview:ideaView];
//        self.currentView = ideaView;
////        ideaView.delegate = self;
//    }
    NSLog(@"current view is %@", self.currentView);
    
//    UIView *testView = [[UIView alloc] init];
//    testView.backgroundColor = [UIColor redColor];
//    testView.frame = CGRectMake(100, 100, 100, 100);
//    [testView enableDragging];
//    [self.view addSubview:testView];
//    UIView *testView2 = [[UIView alloc] init];
//    testView2.backgroundColor = [UIColor blueColor];
//    testView2.frame = CGRectMake(100, 100, 100, 100);
//    [testView2 enableDragging];
//    [self.view addSubview:testView2];
//    
//    IdeaView *test3 = [[IdeaView alloc] init];
//    Idea *testIdea = [[Idea alloc] init];
//    testIdea.title = @"test title";
//    test3.idea = testIdea;
//    [test3 setName:test3.idea.title];
//    test3.backgroundColor = [UIColor yellowColor];
//    test3.frame = CGRectMake(100, 100, 100, 100);
//    [test3 enableDragging];
//    [self.view addSubview:test3];
    
    // test the sp user resizable view
//    CGRect frame = CGRectMake(50, 50, 200, 150);
//        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:frame];
//        UIView *contentView = [[UIView alloc] initWithFrame:frame];
//    [contentView setBackgroundColor:[UIColor redColor]];
//        userResizableView.contentView = contentView;
//        [self.view addSubview:userResizableView];
//
//    CGRect frame2 = CGRectMake(50, 50, 200, 150);
//        SPUserResizableView *userResizableView2 = [[SPUserResizableView alloc] initWithFrame:frame2];
//        UIView *contentView2 = [[UIView alloc] initWithFrame:frame2];
//    [contentView2 setBackgroundColor:[UIColor blueColor]];
//        userResizableView2.contentView = contentView2;
//        [self.view addSubview:userResizableView2];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"I am attemping to move %@", touches);
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
////    NSLog(@"I touched %@", currentView.idea.title);
//}

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

- (void)ideaView:(IdeaView *)ideaView didTap:(Idea *)idea {
    // now we have info about the tapped bubble
    NSLog(@"3 I tapped on %@", idea.title);
    
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
