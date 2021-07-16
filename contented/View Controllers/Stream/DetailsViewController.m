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
//    self.scrollView.backgroundColor = [UIColor systemRedColor];
//    self.scrollView.contentSize = CGSizeMake(500, 1000);
    //
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(setInfo) forControlEvents:UIControlEventValueChanged];
//    [self.scrollView addSubview:self.refreshControl];
//
//    [self.view addSubview:self.scrollView];
//    self.view.backgroundColor = [UIColor blueColor];
}

- (void)setInfo {
    self.titleLabel.text = self.task.title;
    self.ideaDumpLabel.text = self.task.ideaDump;
    NSDate *dueDate = self.task.dueDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE MM/dd"];
    NSString *preText = @"Release on ";
    self.dateLabel.text = [preText stringByAppendingString:[weekday stringFromDate:dueDate]];
    
    // Reset the buttonsStack
    for (UIView* view in self.buttonsStack.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    // Display buttons in stack view for corresponding platforms
    NSDictionary *platforms = self.task.platforms;
    [platforms enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        // key is social media platform, obj is TRUE or FALSE
        PlatformButton *button = [[PlatformButton alloc] init];
        [button setupWithTitleAndState:key :(int)[obj integerValue]];
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsStack addArrangedSubview:button];
    }];
    
}

- (IBAction)onTapRefresh:(id)sender {
    [self setInfo];
}

- (void)onTapPlatformButton:(UIButton*)sender {
    NSDictionary *platforms = self.task.platforms;
    NSString *title = sender.titleLabel.text;
    
    // Platform becomes selected - user has completed this push
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
