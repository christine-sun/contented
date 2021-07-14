//
//  StreamViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "StreamViewController.h"
#import "TaskCell.h"
#import <Parse/Parse.h>

@interface StreamViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfTasks;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTasks];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
   
}

- (void)fetchTasks {
    // construct PFQuery
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query orderByAscending:@"dueDate"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks) {
            self.arrayOfTasks = tasks;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
    
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = self.arrayOfTasks[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTasks.count;
}

#pragma mark - section headers
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getNumOfUniqueDates];
}

- (int)getNumOfUniqueDates {
    NSMutableDictionary *uniqueDates = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < self.arrayOfTasks.count; i++) {
        Task *task = self.arrayOfTasks[i];
        NSDate *date = task.dueDate;
        // Date has NOT been seen before
        if ([uniqueDates objectForKey:date] == nil) {
            [uniqueDates setObject:date forKey:date];
        }
    }
    return uniqueDates.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleField:(id)sender {
}
@end
