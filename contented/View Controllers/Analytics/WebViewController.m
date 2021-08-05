//
//  WebViewController.m
//  contented
//
//  Created by Christine Sun on 7/22/21.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *videoURL;
    // Do any additional setup after loading the view.
    if (self.video == nil) {
        videoURL = @"https://support.google.com/youtube/answer/3250431?hl=en";
    } else {
        videoURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.video.vidID];
    }
    NSURL *url = [NSURL URLWithString:videoURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self.webView loadRequest:request];
    
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
