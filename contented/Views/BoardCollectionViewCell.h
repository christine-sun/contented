//
//  BoardCollectionViewCell.h
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "BoardViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoardCollectionViewCell : UICollectionViewCell<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) BoardViewController *parentVC;

- (void)setupWithBoard: (Board*)board;
- (void)setParentVC:(BoardViewController *)parentVC;

@end

NS_ASSUME_NONNULL_END
