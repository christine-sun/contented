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
@property (strong, nonatomic) UIImage *taskImage;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;


@end

@implementation CreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Style text fields
    self.titleField.layer.borderWidth = 0.5;
    [self.titleField.layer setCornerRadius:10];
    self.ideaDumpField.layer.borderWidth = 0.5;
    [self.ideaDumpField.layer setCornerRadius:10];
    [self.taskImageView.layer setCornerRadius:10];
    
    // Dismiss keyboard outside of text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
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
    
    // Get the image captured by the UIImagePickerController
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end