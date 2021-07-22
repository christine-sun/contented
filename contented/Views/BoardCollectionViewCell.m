//
//  BoardCollectionViewCell.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "BoardCollectionViewCell.h"
#import "BoardTableViewCell.h"

@implementation BoardCollectionViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:10.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.board.items addObject:@"Hi"];
    
    // self.tableView.tableFooterView = UIVIew?/
}

- (void)setupWithBoard: (Board*)board {
    self.board = board;
    [self.tableView reloadData];
}

- (void)setParentVC:(BoardViewController *)parentVC {
    self.parentVC = parentVC;
}

- (IBAction)onTapAdd:(id)sender {
    __block NSString *newTask;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Item" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        newTask = alert.textFields.firstObject.text;
        
    }];
    [alert addAction:addAction];
    
    
    // insert new row at bottom of tableview and scroll to specified index path
    [self.tableView beginUpdates];
    // add new task to board model items array
    [self.board.items addObject:newTask];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.board.items count]-1 inSection:0]];
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView scrollToRowAtIndexPath:indexPath
//                         atScrollPosition:UITableViewScrollPositionTop
//                                 animated:YES];
    [self.tableView endUpdates];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    [alert addAction:cancelAction];
    [self.parentVC presentViewController:alert animated:YES completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.board.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BoardTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.board.items[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.board.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
