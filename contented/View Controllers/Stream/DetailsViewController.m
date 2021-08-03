//
//  DetailsViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "DetailsViewController.h"
#import "EditViewController.h"
#import "PlatformButton.h"
#import "PlatformUtilities.h"
#import <Parse/PFImageView.h>
#import "ColorUtilities.h"

@interface DetailsViewController () <EditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *taskImageView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) NSMutableArray *originalPlatforms;
@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *noImageAddButton;
@property (nonatomic) int completedCount;
@property (nonatomic) int totalToDoCount;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInfo];
    
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.taskImageView.file = self.task[@"image"];
    [self.taskImageView loadInBackground];
    [self.taskImageView.layer setCornerRadius:15];
    
    // Prompt user to set image task did not originally have one
    if (self.task[@"image"] == nil) {
        self.noImageLabel.text = @"It looks like you didn't put an image with this task! Feel free to";
        [self.noImageAddButton setTitle:@"add one." forState:UIControlStateNormal];
    } else {
        self.noImageLabel.text = @"";
        [self.noImageAddButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
}

- (void)setInfo {
    self.titleLabel.text = self.task.title;
    self.ideaDumpLabel.text = self.task.ideaDump;
    NSDate *dueDate = self.task.dueDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE MM/dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"Release on %@ ✨",[weekday stringFromDate:dueDate]];
    
    // Reset the buttonsStack
    for (UIView* view in self.buttonsStack.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    // Display buttons in stack view for corresponding platforms
    self.completedCount = 0;
    self.totalToDoCount = 0;
    NSDictionary *platforms = self.task.platforms;
    [platforms enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        // key is social media platform, obj is TRUE or FALSE
        PlatformButton *button = [[PlatformButton alloc] init];
        [button setup:key:(int)[obj integerValue]:[ColorUtilities getColorFor:@"purple"]];
        if ((int)[obj integerValue] == 1) {
            self.completedCount++;
        }
        self.totalToDoCount++;
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsStack addArrangedSubview:button];
    }];
    
}

- (IBAction)onTapRefresh:(id)sender {
    [self setInfo];
}

- (IBAction)onTapNoImageAddButton:(id)sender {
    [self onTapEdit:self.task];
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
        sender.backgroundColor = [UIColor systemPurpleColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [platforms setValue:@YES forKey:title];
        self.completedCount++;
    // Platform becomes unselected - user uncompleted this push
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemPurpleColor] forState:UIControlStateNormal];
        [platforms setValue:@NO forKey:title];
        self.completedCount--;
    }
    sender.selected = !sender.selected;
    
    // Update this task's dictionary to reflect updated platform statuses
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query getObjectInBackgroundWithId:self.task.objectId
        block:^(PFObject *task, NSError *error) {
            task[@"platforms"] = platforms;
            [task saveInBackground];
    }];
    
    // If all platforms are selected, this means the task is completed!
    // the size of the array for
    if (self.completedCount == self.totalToDoCount)
        [self showCompletedMessage];
}

- (void)showCompletedMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"COMPLETED TASK!!🎉"
        message:@"omg congrats on pushing this out for the world to see! you are amazing and keep up the awesome work🥳"
        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YAAASSS"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            PFQuery *query = [PFQuery queryWithClassName:@"Task"];
            [query getObjectInBackgroundWithId:self.task.objectId
                block:^(PFObject *task, NSError *error) {
                    task[@"completed"] = @(1);
                    [task saveInBackground];
            }];
        // in future iterations, this could navigate to a profile tab with a progress bar/level of this user showing how many tasks are completed. it might also go to the analytics tab. for now, i'm going to bring it back to the stream
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleDoubleTap:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"complete task?"
            message:@"have you completed all pushes for this task?"
            preferredStyle:(UIAlertControllerStyleAlert)];
        
        // YES - task is completed
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"you know it 😎"
            style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self showCompletedMessage];
            
        }];
        [alert addAction:yesAction];
        
        // NO - dismiss
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"oop lemme do that rn!" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:noAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didUpdate:(Task *)task {
    // Update this task to reflect updated info
    self.task = task;
    [self setInfo];
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
        editVC.delegate = self;
    }
}

@end
