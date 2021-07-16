//
//  DetailsViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "DetailsViewController.h"
#import "EditViewController.h"
#import "PlatformButton.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *originalPlatforms;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInfo];
    
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    //
    self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.contentSize = CGSizeMake(500, 1000);
    //
    self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(updateTask) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];

    [self.view addSubview:self.scrollView];
}

// state is 0 if we are setting up the stackview for the first time. state is 1 if we are updating it after a change
- (void)setInfo {
    self.titleLabel.text = self.task.title;
    self.ideaDumpLabel.text = self.task.ideaDump;
    NSDate *dueDate = self.task.dueDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE MM/dd"];
    NSString *preText = @"Release on ";
    self.dateLabel.text = [preText stringByAppendingString:[weekday stringFromDate:dueDate]];
    
    // Display buttons in stack view for corresponding platforms
    NSDictionary *platforms = self.task.platforms;
    // reset the butonsStack
//    self.buttonsStack = [[UIStackView alloc] init];
    for (UIView* view in self.buttonsStack.arrangedSubviews) {
//        NSLog(@"%@", view);
//        [self.buttonsStack removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    NSLog(@"should be empty %@", self.buttonsStack);
    
    [platforms enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        // key is social media platform, obj is TRUE or FALSE
        PlatformButton *button = [[PlatformButton alloc] init];
        [button setupWithTitleAndState:key :(int)[obj integerValue]];
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
        // Only add button to stack if this is the first time you're loading it or it's not there already
//        if (state == 0 || (state == 1 && !([self.originalPlatforms containsObject:key]))) {
            [self.buttonsStack addArrangedSubview:button];
//        }
    }];
}

- (void)updateTask {
    
//    self.originalPlatforms = [[NSMutableArray alloc] init];
    // HOW TO ITERATE THROUGH A STACKVIEW??
    //for (UIButton *button in self.buttonsStack)
    //{
       // UIButton *button = UIButton in view;
//        [self.originalPlatforms addObject:button.titleLabel.text];
//    }
    [self setInfo];
    [self.refreshControl endRefreshing];
}

- (void)onTapPlatformButton:(UIButton*)sender {
    NSDictionary *platforms = self.task.platforms;
    NSString *title = sender.titleLabel.text;
    
    // Platform becomes selected - user has completed this push
    NSLog(@"1 %d", sender.selected);
    NSLog(@"2 %@", [platforms objectForKey:title]);
    NSString *state = [platforms objectForKey:title];
    int prevState = [state intValue];
    if (prevState == 1 && !sender.selected) {
        sender.selected = !sender.selected;
    }
    if(!sender.selected) {
        sender.backgroundColor = [UIColor systemTealColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [platforms setValue:@YES forKey:title];
    // Platform becomes unselected - user uncompleted this push
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
        [platforms setValue:@NO forKey:title];
    }
    sender.selected = !sender.selected;
    NSLog(@"%@", platforms);
    // Update this task's dictionary to reflect updated platform statuses
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query getObjectInBackgroundWithId:self.task.objectId
        block:^(PFObject *task, NSError *error) {
            task[@"platforms"] = platforms;
            [task saveInBackground];
    }];
}

- (IBAction)onTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:self.task];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"editSegue"]) {
        EditViewController *editVC = [segue destinationViewController];
        editVC.task = sender;
    }
}

@end
