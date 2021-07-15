//
//  EditViewController.m
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import "EditViewController.h"
#import <Parse/PFImageView.h>

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *ideaDumpField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet PFImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleField.text = self.task.title;
    self.ideaDumpField.text = self.task.ideaDump;
    self.datePicker.date = self.task.dueDate;
    self.taskImageView.file = self.task[@"image"];
    [self.taskImageView loadInBackground];
}

- (IBAction)onTapXButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
