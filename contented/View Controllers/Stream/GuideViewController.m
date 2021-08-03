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
    UIView *view0 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view0.backgroundColor = [UIColor systemPurpleColor];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
