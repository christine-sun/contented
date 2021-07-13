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
    NSLog(@"type is %@, title is %@, ideaDump is %@, image is %@", self.type, self.taskTitle, self.ideaDump, self.taskImage);
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
