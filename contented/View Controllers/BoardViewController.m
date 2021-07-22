//
//  BoardViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "BoardViewController.h"
#import "Board.h"
#import "BoardCollectionViewCell.h"

@interface BoardViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *boards;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // didnt do updateCollectionViewItem 2 and 3
    Board *newBoard = [[Board alloc] init];
    newBoard.title = @"To Do";
    newBoard.items = @[@"first item", @"second item"];
    [self.boards addObject:newBoard];
}

- (IBAction)onTapNewList:(id)sender {
    __block NSString* newList;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add List" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        newList = alert.textFields.firstObject.text;
        Board *newBoard = [[Board alloc] init];
        newBoard.title = newList;
        newBoard.items = [[NSMutableArray alloc] init];
        [self.boards addObject:newBoard];
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.boards.count-1 inSection:0]];
        [self.collectionView insertItemsAtIndexPaths:paths];
        
    }];
    [alert addAction:addAction];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.boards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"BoardCollectionViewCell" forIndexPath:indexPath];
    [cell setupWithBoard:self.boards[indexPath.item]];
    [cell setParentVC:self];
    return cell;
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
