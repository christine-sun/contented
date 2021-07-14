//
//  TabBarController.m
//  contented
//
//  Created by Christine Sun on 7/14/21.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *createVC = [storyboard instantiateViewControllerWithIdentifier:@"CreationViewController"];
    if (self.selectedIndex == 1) {
        self.selectedViewController.view.window.rootViewController = createVC;
    }
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
