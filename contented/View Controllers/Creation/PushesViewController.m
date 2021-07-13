//
//  PushesViewController.m
//  contented
//
//  Created by Christine Sun on 7/13/21.
//

#import "PushesViewController.h"
#import "Platform.h"

@interface PushesViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) NSArray *platforms;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDumpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation PushesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.type = @"long"; //fortesting
//    if ([self.type isEqualToString:@"long"]) {
//        NSMutableArray *platforms = [NSMutableArray array];
//        [platforms addObject:[[Platform alloc] init]];
//        // NEED HELP: how should we handle the array of paltformshttps://www.youtube.com/watch?v=cVBrbpJdgyg
//    }
    // test to see if info from before was sent over correctly
//    NSLog(@"type is %@, title is %@, ideaDump is %@, image is %@", self.type, self.taskTitle, self.ideaDump, self.taskImage);
    self.titleLabel.text = self.taskTitle;
    self.ideaDumpLabel.text = self.ideaDump;
    [self.taskImageView setImage:self.taskImage];
    NSString *typeString = @"New ";
    typeString = [typeString stringByAppendingString:self.type];
    self.typeLabel.text = typeString;
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
