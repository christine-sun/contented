//
//  EditViewController.m
//  contented
//
//  Created by Christine Sun on 7/15/21.
//

#import "EditViewController.h"
#import <Parse/PFImageView.h>
#import "PlatformUtilities.h"
#import "PlatformButton.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *ideaDumpField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet PFImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) NSMutableDictionary *updatedPlatforms;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleField.text = self.task.title;
    self.ideaDumpField.text = self.task.ideaDump;
    self.datePicker.date = self.task.dueDate;
    self.taskImageView.file = self.task[@"image"];
    [self.taskImageView loadInBackground];
    [self.taskImageView.layer setCornerRadius:15];
    self.updatedPlatforms = self.task.platforms;
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Configure available platforms based on task type
    NSArray *platforms = [PlatformUtilities getPlatformsForType:self.task.type];
    
    // Display buttons in stack view for all platforms
    for (int i = 0; i < platforms.count; i++) {
        PlatformButton *button = [[PlatformButton alloc] init];
        NSString *platformName = platforms[i];
        int state = ([self.task.platforms objectForKey:platformName] == nil) ? 0 : 1;
        NSLog(@"%d", state);
        [button setupWithTitleAndState:platforms[i]:state];
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsStack addArrangedSubview:button];
    }
    
}

- (void)onTapPlatformButton:(UIButton*)sender {
    NSString *title = sender.titleLabel.text;
    
    // Platform was not initially selected - add this to list of platforms
    if ([self.updatedPlatforms objectForKey:title] == nil) {
        sender.backgroundColor = [UIColor systemTealColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.updatedPlatforms setValue:@NO forKey:title];
        
    // Platform was initially selected - remove from list of platforms
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
        
        [self.updatedPlatforms removeObjectForKey:title];
    }
    
}

- (IBAction)onTapXButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapUpdate:(id)sender {
    // Update this task's dictionary to reflect updated platform statuses
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query getObjectInBackgroundWithId:self.task.objectId
        block:^(PFObject *task, NSError *error) {
            task[@"title"] = self.titleField.text;
            task[@"ideaDump"] = self.ideaDumpField.text;
            task[@"image"] = self.taskImageView.file;
            task[@"dueDate"] = self.datePicker.date;
            task[@"platforms"] = self.updatedPlatforms;
            [task saveInBackground];
    }];
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
