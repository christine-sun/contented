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

@interface StreamViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfTasks;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableDictionary *uniqueDates;
@property (strong, nonatomic) NSMutableArray *groupedTasks;
@property (nonatomic) int section;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.section = 0;

    [self fetchTasks];
    
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
        [self fetchTasks];
        
    }];
    [alert addAction:yesAction];
    
    // NO - dismiss
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"oop lemme do that rn!" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:noAction];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    return [self getNumOfUniqueDates];
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
    Task *task = [[self.groupedTasks objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailsSegue" sender:task];
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

@end
