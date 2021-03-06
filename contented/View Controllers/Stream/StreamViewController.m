//
//  StreamViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "StreamViewController.h"
#import "DetailsViewController.h"
#import "TaskCell.h"
#import <Parse/Parse.h>
#import "LMDropdownView.h"
#import "FilterCell.h"
#import "DesignUtilities.h"
#import "GuideViewController.h"
#import "ConfettiUtilities.h"

@interface StreamViewController () <UITableViewDelegate, UITableViewDataSource, LMDropdownViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfTasks;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *uniqueDates;
@property (strong, nonatomic) NSMutableArray *groupedTasks;
@property (nonatomic) int section;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtextLabel;
@property (strong, nonatomic) UIButton *createTaskButton;

@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) LMDropdownView *filterView;
@property (strong, nonatomic) NSArray *filterTypes;
@property (assign, nonatomic) NSInteger currentFilterTypeIndex;

@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.section = 0;
    [self.tableView.layer setCornerRadius:15];
    self.tableView.tableHeaderView = self.headerView;

    [self fetchTasks];
    
    self.filterTypes = @[@"To Do", @"Completed", @"YouTube", @"Instagram", @"TikTok", @"Snapchat", @"Twitter"];
    self.currentFilterTypeIndex = 0;
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    self.filterView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    PFUser *currentUser = [PFUser currentUser];
    self.headerLabel.text = [NSString stringWithFormat:@"hey, %@!????",currentUser.username];
    
    [DesignUtilities fadeIn:self.headerView withDuration:0.8];
    [DesignUtilities fadeIn:self.tableView withDuration:0.8];
}

- (void)fetchTasks {
    [self.activityIndicator startAnimating];
    
    // construct PFQuery
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query orderByAscending:@"dueDate"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    if (self.currentFilterTypeIndex == 1) {
        [query whereKey:@"completed" equalTo:@(1)];
    } else {
        [query whereKey:@"completed" equalTo:@(0)];
    }
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks) {
            
            if (self.currentFilterTypeIndex > 1) {
                // Only display tasks that contain this platform as a push
                NSString *platformName = self.filterTypes[self.currentFilterTypeIndex];
                NSMutableArray *tasksOfPlatform = [[NSMutableArray alloc] init];
                for (int i = 0; i < tasks.count; i++) {
                    Task *task = tasks[i];
                    NSDictionary *platforms = task[@"platforms"];
                    if ([platforms objectForKey:platformName] != nil) {
                        [tasksOfPlatform addObject:task];
                    }
                }
                self.arrayOfTasks = tasksOfPlatform;
            }
            
            else {
                self.arrayOfTasks = tasks;
            }
            
            [self.tableView reloadData];
            
            if (tasks.count > 0) {
                self.subtextLabel.text = @"you're doing gr8 - let's see what's coming up and get this bread ????";
                self.createTaskButton.alpha = 0;
                [self.createTaskButton setUserInteractionEnabled:NO];
            } else {
                if (self.currentFilterTypeIndex == 1) {
                    self.subtextLabel.text = @"you haven't completed any tasks yet";
                } else {
                    self.subtextLabel.text = @"it looks like you don't have any active tasks! let's create one together! ????";
                    self.createTaskButton = [[UIButton alloc] init];
                    self.createTaskButton.backgroundColor = [UIColor systemTealColor];
                    [self.createTaskButton setTitle: @"Create Task" forState: UIControlStateNormal];
                    self.createTaskButton.titleLabel.textColor = [UIColor whiteColor];
                    self.createTaskButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:18];
                    [self.createTaskButton setFrame:CGRectMake(self.view.center.x - 75, self.view.center.y, 150, 50)];
                    [self.createTaskButton addTarget:self
                                 action:@selector(goToCreate)
                       forControlEvents:UIControlEventTouchUpInside];
                    [self.createTaskButton.layer setCornerRadius:15];
                    
                    [self.view addSubview:self.createTaskButton];
                }
            }
        }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
    
}

- (void)goToCreate {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
}

- (void)taskCell:(TaskCell *)taskCell didTap:(Task *)task {
    [self confirmCompletion:taskCell];
}

- (void)confirmCompletion:(TaskCell *)taskCell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"complete task?"
        message:@"have you completed all pushes for this task?"
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // YES - task is completed
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"you know it ????"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Update this task's status to completed = 1
        PFQuery *query = [PFQuery queryWithClassName:@"Task"];
        [query getObjectInBackgroundWithId:taskCell.task.objectId
            block:^(PFObject *task, NSError *error) {
                task[@"completed"] = @(1);
                [task saveInBackground];
        }];
        
    }];
    [alert addAction:yesAction];
    
    // NO - dismiss
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"oop lemme do that rn!" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:noAction];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
        [cell setIsCompleted:self.currentFilterTypeIndex == 1];
        cell.task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.contentView.backgroundColor =  [DesignUtilities getColorFor:cell.task.type];
        cell.contentView.backgroundColor = [cell.contentView.backgroundColor colorWithAlphaComponent:0.5];
        
        return cell;
    }
    /* FILTER TABLE VIEW */
    else {
        FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
        [cell setTitle:[self.filterTypes objectAtIndex:indexPath.row] isSelected:(indexPath.row == self.currentFilterTypeIndex)];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        NSArray *thisDatesTasks;
        int lastIndex = self.groupedTasks.count - 1;
        if (section == lastIndex) {
            thisDatesTasks = self.groupedTasks[lastIndex];
        } else {
            thisDatesTasks = self.groupedTasks[self.section];
            self.section++;
        }
        
        // Reset section count for future reuse
        if (self.section == self.groupedTasks.count - 1) {
            self.section = 0;
        }
        return thisDatesTasks.count;
        
    }
    /* FILTER TABLE VIEW */
    else {
        return [self.filterTypes count];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        // Define the initial state (Before the animation)
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        [UIView animateWithDuration:0.8 animations:^{
                cell.alpha = 1;
                cell.layer.shadowOffset = CGSizeMake(0, 0);
        }];
    }
}

#pragma mark - section headers

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        UILabel *label = [[UILabel alloc] init];
        Task *task = [[self.groupedTasks objectAtIndex:section] objectAtIndex:0];
        NSDate *dueDate = task.dueDate;
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
        [weekday setDateFormat: @"EEEE MM/dd"];
        label.text = [weekday stringFromDate:dueDate];
        [label setFont:[UIFont fontWithName:@"Avenir" size:17]];

        return label;
    }
    /* FILTER TABLE VIEW */
    else {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Filter";
        [label setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:30]];
        return label;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        return [self getNumOfUniqueDates];
    }
    /* FILTER TABLE VIEW */
    else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        return 20;
    }
    /* FILTER TABLE VIEW */
    else {
        return 75;
    }
}

- (int)getNumOfUniqueDates {
    self.uniqueDates = [[NSMutableDictionary alloc] init];
    NSMutableArray *tasksWithSameDate = [[NSMutableArray alloc] init];
    self.groupedTasks = [[NSMutableArray alloc] init];
    [self.groupedTasks addObject:tasksWithSameDate];
    int index = 0;
  
    for (int i = 0; i < self.arrayOfTasks.count; i++) {
        Task *task = self.arrayOfTasks[i];
        NSString *date = [self dateToString:task.dueDate];
        NSArray *firstDate = [self.groupedTasks objectAtIndex:0];
        if (firstDate.count != 0) {
            // This is not the first item in the array
            Task *prevDateTask = [[self.groupedTasks objectAtIndex:index] objectAtIndex:0];
            NSString *prevDate = [self dateToString:prevDateTask.dueDate];
            if ([date isEqualToString:prevDate]) {
                [tasksWithSameDate addObject:task];
            } else {
                // different date - add this array, make a new array at next slot, and add task
                [self.groupedTasks setObject:tasksWithSameDate atIndexedSubscript:index];
                index++;
                tasksWithSameDate = [[NSMutableArray alloc] init];
                [tasksWithSameDate addObject:task];
                [self.groupedTasks setObject:tasksWithSameDate atIndexedSubscript:index];
            }
        } else {
            // this is the first item in the array
            [tasksWithSameDate addObject:task];
        }
   
        // Date has NOT been seen before
        if ([self.uniqueDates objectForKey:date] == nil) {
            [self.uniqueDates setObject:[NSString stringWithFormat:@"%d", 1] forKey:date];
        }
        // Date has been seen - update the count
        else {
            NSString *currentCount = [self.uniqueDates objectForKey:date];
            int count = [currentCount integerValue];
            count++;
            currentCount = [NSString stringWithFormat:@"%d", count];
            [self.uniqueDates setObject:currentCount forKey:date];
        }
    }
    return self.uniqueDates.count;
}

- (NSString*)dateToString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/YY";
    return [formatter stringFromDate:date];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /* TASKS TABLE VIEW */
    if (tableView == self.tableView) {
        Task *task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"detailsSegue" sender:task];
    }
    /* FILTER TABLE VIEW */
    else {
        [self.filterTableView deselectRowAtIndexPath:indexPath animated:NO];
        self.currentFilterTypeIndex = indexPath.row;
        [self.filterView hide];
        [self fetchTasks];
    }
}

#pragma mark - Dropdown View
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.filterTableView.frame = CGRectMake(CGRectGetMinX(self.filterTableView.frame),
        CGRectGetMinY(self.filterTableView.frame),
        CGRectGetWidth(self.view.bounds), self.filterTypes.count * 83 + self.filterTableView.sectionHeaderHeight);
}

- (void)showDropDownViewFromDirection:(LMDropdownViewDirection)direction
{
    // Init dropdown view
    if (!self.filterView) {
        self.filterView = [LMDropdownView dropdownView];
        self.filterView.delegate = self;

        // Customize Dropdown style
        self.filterView.blurRadius = 5;
        self.filterView.animationDuration = 0.5;
        self.filterView.animationBounceHeight = 20;
    }
    self.filterView.direction = direction;

    // Show/hide dropdown view
    if ([self.filterView isOpen]) {
        [self.filterView hide];
    }
    else {
        [self.filterView showFromNavigationController:self.navigationController
            withContentView:self.filterTableView];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailsSegue"]) {
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.task = (Task*)sender;
    } else if ([segue.identifier isEqual:@"guideSegue"]) {
        GuideViewController *guideVC = [segue destinationViewController];
        guideVC.state = 0;
    }
}

- (IBAction)onTapFilterButton:(id)sender {
    [self.filterTableView reloadData];
    [self showDropDownViewFromDirection:LMDropdownViewDirectionTop];
}

- (IBAction)onTapGuideButton:(id)sender {
    [self performSegueWithIdentifier:@"guideSegue" sender:nil];
}

@end
