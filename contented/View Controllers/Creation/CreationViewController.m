//
//  CreationViewController.m
//  contented
//
//  Created by Christine Sun on 7/12/21.
//

#import "CreationViewController.h"
#import "PushesViewController.h"
#import "Task.h"
#import "ColorUtilities.h"

@interface CreationViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *ideaDumpField;
@property (weak, nonatomic) IBOutlet UILabel *releaseOnLabel;
@property (strong, nonatomic) UIImage *taskImage;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *shortButton;
@property (weak, nonatomic) IBOutlet UIButton *longButton;

@end

@implementation CreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Style text fields
    [self.titleField.layer setCornerRadius:10];
    [self.ideaDumpField.layer setCornerRadius:10];
    self.releaseOnLabel.layer.masksToBounds = YES;
    [self.releaseOnLabel.layer setCornerRadius:10];
    [self.taskImageView.layer setCornerRadius:10];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.titleField.leftView = paddingView;
    self.titleField.leftViewMode = UITextFieldViewModeAlways;
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
        
    // Default values
    self.titleField.text = @"";
    self.ideaDumpField.delegate = self;
    self.ideaDumpField.text = @"toss your idea dump here! let those creative juices flow🎨";
    self.ideaDumpField.textColor = [UIColor systemGray3Color];
    self.ideaDumpField.font = [UIFont systemFontOfSize:20];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.date = [NSDate date];
    [self.taskImageView setImage:[UIImage imageNamed:@"placeholder"]];
    
    // Style the platform type buttons
    [self styleButton:self.postButton:@"post"];
    [self styleButton:self.shortButton:@"short"];
    [self styleButton:self.longButton:@"long"];
}

- (void)styleButton:(UIButton*)button:(NSString*)type {
    [button.layer setCornerRadius:10];
    button.backgroundColor = [ColorUtilities getColorFor:type];
    [ColorUtilities addShadow:button.titleLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    // If this task already exists, clear the text fields
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"title" equalTo:self.titleField.text];
    [query whereKey:@"ideaDump" equalTo:self.ideaDumpField.text];
    [query whereKey:@"dueDate" equalTo:self.datePicker.date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (objects.count > 0) {
        [self viewDidLoad];
      }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == [UIColor systemGray3Color]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"toss your idea dump here! let those creative juices flow🎨";
        textView.textColor = [UIColor systemGray3Color];
    }
}

-(void)dismissKeyboard {
    [self.titleField resignFirstResponder];
    [self.ideaDumpField resignFirstResponder];
}

- (IBAction)onTapCamera:(id)sender {
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (IBAction)onTapPhotoAlbum:(id)sender {
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {

    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Resize image before uploading
    CGSize imageDimensions = CGSizeMake(1000, 1000);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:imageDimensions];
    self.taskImage = resizedImage;
    [self.taskImageView setImage:resizedImage];
        
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)checkValidEntries {
    if ([self.titleField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title required"
            message:@"make sure you have a title for your task😊"
            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"okay!"
            style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else return YES;
}

- (IBAction)onTapLong:(id)sender {
    if ([self checkValidEntries]) {
        [self performSegueWithIdentifier:@"pushesSegue" sender:@"long"];
    }
}

- (IBAction)onTapShort:(id)sender {
    if ([self checkValidEntries]) {
        [self performSegueWithIdentifier:@"pushesSegue" sender:@"short"];
    }
}

- (IBAction)onTapPost:(id)sender {
    if ([self checkValidEntries]) {
        [self performSegueWithIdentifier:@"pushesSegue" sender:@"post"];
    }
}

- (void)didEdit:(NSString *)taskTitle :(NSString *)taskIdeas :(UIImage *)taskImage {
    self.titleField.text = taskTitle;
    self.ideaDumpField.text = taskIdeas;
    [self.taskImageView setImage:taskImage];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"pushesSegue"]) {
        PushesViewController *pushesVC = [segue destinationViewController];
        pushesVC.type = sender;
        pushesVC.taskTitle = self.titleField.text;
        pushesVC.ideaDump = self.ideaDumpField.text;
        pushesVC.date = self.datePicker.date;
        pushesVC.taskImage = self.taskImage;
    }
}

@end
