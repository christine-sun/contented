//
//  GuideViewController.m
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import "GuideViewController.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *viewArray;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view0 = [self setUpView:@"Intention Setting" withImage:@"intentionsetting" withDescription:@"Research has shown that being intentional about the upcoming week leads to clearer direction and getting more done. Create your tasks for the upcoming week at an established time each week (we recommend Sunday evening!)"];
//    UIView *view0 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    UIImage *intentionSetting = [UIImage imageNamed:@"intentionsetting"];
//    UIImageView *imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
//    [imageView0 setImage:intentionSetting];
//    [view0 addSubview:imageView0];
//
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 500, 100)];
//    title.text = @"Intention Setting";
//    [title setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
//    [view0 addSubview:title];
//
//    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(25, 240, view0.frame.size.width - 50, 200)];
//    description.numberOfLines = 0;
//    description.textAlignment = NSTextAlignmentCenter;
//    description.text = @"Research has shown that being intentional about the upcoming week leads to clearer direction and getting more done. Create your tasks for the upcoming week at an established time each week (we recommend Sunday evening!)";
//    [description setFont:[UIFont fontWithName:@"Avenir" size:18]];
//    [view0 addSubview:description];
    
    
    //
    UIView *view1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view1.backgroundColor = [UIColor systemRedColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view2.backgroundColor = [UIColor systemTealColor];
    
    self.viewArray = [[NSMutableArray alloc] init];
    [self.viewArray addObject:view0];
    [self.viewArray addObject:view1];
    [self.viewArray addObject:view2];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView isPagingEnabled];
    self.scrollView.contentSize = CGSizeMake(view0.frame.size.width * self.viewArray.count, view0.frame.size.height);
    self.doneButton.alpha = 0;
    
    for (int i = 0; i < self.viewArray.count; i++) {
        UIView *view = self.viewArray[i];
        [self.scrollView addSubview:view];
        view.frame = CGRectMake(view.frame.size.width * i, 0, view.frame.size.width, view.frame.size.height);
    }
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.frame.size.height);
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 90, self.scrollView.frame.size.width, 20)];
    self.pageControl.numberOfPages = self.viewArray.count;
    [self.pageControl addTarget:self action:@selector(pageControlTapHandler:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView*)setUpView: (NSString*) title withImage: (NSString*) imageName withDescription: (NSString*) description {
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
    [imageView setImage:image];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 500, 100)];
    titleLabel.text = title;
    [titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [view addSubview:titleLabel];
    
    UILabel *subtext = [[UILabel alloc] initWithFrame:CGRectMake(25, 240, view.frame.size.width - 50, 200)];
    subtext.numberOfLines = 0;
    subtext.textAlignment = NSTextAlignmentCenter;
    subtext.text = description;
    [subtext setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [view addSubview:subtext];
    
    return view;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageNumber = roundf(self.scrollView.contentOffset.x / (self.scrollView.frame.size.width));
    self.pageControl.currentPage = pageNumber;
    if (pageNumber == self.viewArray.count - 1) {
        [UIView animateWithDuration:0.8 animations:^{
            self.doneButton.alpha = 1;
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageNumber = roundf(self.scrollView.contentOffset.x / (self.scrollView.frame.size.width));
    self.pageControl.currentPage = pageNumber;
}

- (void)pageControlTapHandler: (UIPageControl*) sender {
    CGFloat x = self.pageControl.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (IBAction)onTapDone:(id)sender {
    // segue to stream VC
    // if it's being presented modally, then dismiss the modal popover. else, just modally present fully the stream vc
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
