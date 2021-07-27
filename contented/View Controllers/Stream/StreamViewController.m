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

@interface StreamViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfTasks;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *uniqueDates;
@property (strong, nonatomic) NSMutableArray *groupedTasks;
@property (nonatomic) int section;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *headerView;

// test begin
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) LMDropdownView *filterView;
@property (strong, nonatomic) NSArray *filterTypes;
@property (assign, nonatomic) NSInteger currentFilterTypeIndex;


// test end

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
    // start
    self.filterTypes = @[@"To Do", @"Completed", @"YouTube", @"Instagram", @"TikTok", @"Snapchat", @"Twitter"];
    self.currentFilterTypeIndex = 0;
    self.filterView = [LMDropdownView dropdownView];
    // end
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
   
}

- (void)fetchTasks {
    [self.activityIndicator startAnimating];
    
    // construct PFQuery
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query orderByAscending:@"dueDate"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"completed" equalTo:@(0)];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks) {
            self.arrayOfTasks = tasks;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
    
}

- (void)taskCell:(TaskCell *)taskCell didTap:(Task *)task {
    // TODO: show notif like r u sure u completed all pushes? and then be like updating the backend and like WOW YAY
    [self confirmCompletion:taskCell];
}

- (void)confirmCompletion:(TaskCell *)taskCell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"complete task?"
        message:@"have you completed all pushes for this task?"
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // YES - task is completed
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"you know it 😎"
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Change button image
        //[taskCell.checkButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateNormal]; - how can we make the checkbox not persist in cell after refresh?
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
    if (tableView == self.tableView) {
        TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
        cell.task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    else {
        FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
        if (!cell) {
            cell = [[FilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
        }
        
        cell.menuItemLabel.text = [self.filterTypes objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    } else {
        return [self.filterTypes count];
    }
    
}

#pragma mark - section headers

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    //label.text = [NSString stringWithFormat:@"section %ld",(long)section];;
    // label.backgroundColor make it a transparent white
    Task *task = [[self.groupedTasks objectAtIndex:section] objectAtIndex:0];
    NSDate *dueDate = task.dueDate;
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE MM/dd"];
    label.text = [weekday stringFromDate:dueDate];
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return [self getNumOfUniqueDates];
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
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
            // This is not hte first item in the array
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
    if (tableView == self.tableView) {
        Task *task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"detailsSegue" sender:task];
    } else {
        [self.filterTableView deselectRowAtIndexPath:indexPath animated:NO];
        self.currentFilterTypeIndex = indexPath.row;
        [self.filterView hide];
    }
}

#pragma mark - Dropdown View
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.filterTableView.frame = CGRectMake(CGRectGetMinX(self.filterTableView.frame),
        CGRectGetMinY(self.filterTableView.frame),
        CGRectGetWidth(self.view.bounds),
        MIN(CGRectGetHeight(self.view.bounds) - 50, self.filterTypes.count * 50));
}

- (void)showDropDownViewFromDirection:(LMDropdownViewDirection)direction
{
    // Init dropdown view
    if (!self.filterView) {
        self.filterView = [LMDropdownView dropdownView];
        self.filterView.delegate = self;
        
        // Customize Dropdown style
        self.filterView.closedScale = 0.85;
        self.filterView.blurRadius = 5;
        self.filterView.blackMaskAlpha = 0.5;
        self.filterView.animationDuration = 0.5;
        self.filterView.animationBounceHeight = 20;
    }
    self.filterView.direction = direction;
    
    // Show/hide dropdown view
    if ([self.filterView isOpen]) {
        [self.filterView hide];
    }
    else {
        switch (direction) {
            case LMDropdownViewDirectionTop: {
                self.filterView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
                
                [self.filterView showFromNavigationController:self.navigationController
                                                withContentView:self.filterTableView];
                break;
            }
            default:
                break;
        }
    }
}

- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view did hide");
    
    switch (self.currentFilterTypeIndex) {
        case 0:
            // do something
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"detailsSegue"]) {
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.task = (Task*)sender;
    }
}

- (IBAction)onTapFilterButton:(id)sender {
    [self.filterView showFromNavigationController:self.navigationController withContentView:self.filterTableView];
}


@end
