//
//  CreationViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "CreationViewController.h"

@interface CreationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *ideaDumpField;


@end

@implementation CreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleField.layer.borderWidth = 0.5;
    [self.titleField.layer setCornerRadius:10];
    self.ideaDumpField.layer.borderWidth = 0.5;
    [self.ideaDumpField.layer setCornerRadius:10];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    
}

-(void)dismissKeyboard {
    [self.titleField resignFirstResponder];
    [self.ideaDumpField resignFirstResponder];
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
