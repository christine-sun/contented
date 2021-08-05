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
#import "Task.h"
#import "DesignUtilities.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *ideaDumpField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *releaseOnLabel;
@property (weak, nonatomic) IBOutlet PFImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStack;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) NSMutableDictionary *updatedPlatforms;
@property (strong, nonatomic) UIImage *updatedImage;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleField.text = self.task.title;
    self.ideaDumpField.text = self.task.ideaDump;
    self.releaseOnLabel.layer.masksToBounds = YES;
    [self.releaseOnLabel.layer setCornerRadius:10];
    [self.ideaDumpField.layer setCornerRadius:10];
    self.datePicker.date = self.task.dueDate;
    self.taskImageView.file = self.task[@"image"];
    [self.taskImageView loadInBackground];
    [self.taskImageView.layer setCornerRadius:15];
    self.updatedPlatforms = self.task.platforms;
    
//    self.view.backgroundColor = [ColorUtilities getColorFor:@"blue"];
    self.updatedImage = nil;
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
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
        [button setup:platforms[i]:state:[UIColor whiteColor]];
        if (state == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[DesignUtilities getColorFor:@"blue"] forState:UIControlStateNormal];
        }
        [button addTarget:self action: @selector(onTapPlatformButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsStack addArrangedSubview:button];
    }
}

-(void)dismissKeyboard {
    [self.titleField resignFirstResponder];
    [self.ideaDumpField resignFirstResponder];
}

- (void)onTapPlatformButton:(UIButton*)sender {
    NSString *title = sender.titleLabel.text;
    
    // Platform was not initially selected - add this to list of platforms
    if ([self.updatedPlatforms objectForKey:title] == nil) {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[DesignUtilities getColorFor:@"blue"] forState:UIControlStateNormal];
        
        [self.updatedPlatforms setValue:@NO forKey:title];
        
    // Platform was initially selected - remove from list of platforms
    } else {
        sender.backgroundColor = [UIColor clearColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.updatedPlatforms removeObjectForKey:title];
    }
    
}
- (IBAction)onTapChangeImage:(id)sender {
    if (self.imagePickerVC.allowsEditing) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {

    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Resize image before uploading
    CGSize imageDimensions = CGSizeMake(1000, 1000);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:imageDimensions];
    self.updatedImage = resizedImage;
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

- (IBAction)onTapXButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapUpdate:(id)sender {
    
    if (self.updatedPlatforms.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"did you mean to delete this task?"
            message:@"can't have 0 platforms for a task"
            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"I see"
            style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        // Update this task's dictionary to reflect updated platform statuses
        PFQuery *query = [PFQuery queryWithClassName:@"Task"];
        [query getObjectInBackgroundWithId:self.task.objectId
            block:^(PFObject *task, NSError *error) {
                task[@"title"] = self.titleField.text;
                task[@"ideaDump"] = self.ideaDumpField.text;
                if (self.taskImageView.file != nil)
                    task[@"image"] = self.taskImageView.file;
                task[@"dueDate"] = self.datePicker.date;
                task[@"platforms"] = self.updatedPlatforms;
                if (self.updatedImage != nil)
                    task[@"image"] = [Task getPFFileFromImage:self.updatedImage];
                [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        // Re-fetch this task
                        PFQuery *query = [PFQuery queryWithClassName:@"Task"];
                        [query whereKey:@"objectId" equalTo:self.task.objectId];
                        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                            self.task = objects[0];
                            
                            [self.delegate didUpdate:self.task];
                        
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                    } else {
                        // present an alert that says - there was a problem updating this task
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Updating Task"
                            message:error.localizedDescription
                            preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok"
                            style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
        }];
    }
}

- (IBAction)onTapDelete:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"delete task"
        message:@"are you sure you want to delete this task?"
        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // NO - Dismiss alert
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"no"
        style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:noAction];
    
    // YES - Delete Task from backend and return to Stream
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"yes"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [PFObject deleteAll:@[self.task]];
            [self performSegueWithIdentifier:@"returnStreamSegue" sender:nil];
        }];
    [alert addAction:yesAction];

    [self presentViewController:alert animated:YES completion:nil];
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
