//
//  GuideViewController.m
//  contented
//
//  Created by Christine Sun on 8/3/21.
//

#import "GuideViewController.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *viewArray;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view0 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view0.backgroundColor = [UIColor systemPurpleColor];
    NSLog(@"is this even valid %@", view0);
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor systemRedColor];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor systemTealColor];
    [self.viewArray addObject:view0];
    [self.viewArray addObject:view1];
    [self.viewArray addObject:view2];
    
//    self.scrollView.backgroundColor = [UIColor yellowColor];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView isPagingEnabled];
    self.scrollView.contentSize = CGSizeMake(view0.frame.size.width * self.viewArray.count, view0.frame.size.height);
    
    for (int i = 0; i < self.viewArray.count; i++) {
        UIView *view = self.viewArray[i];
        [self.scrollView addSubview:view];
        view.frame = CGRectMake(view.frame.size.width * i, 0, view.frame.size.width, view.frame.size.height);
    }
    self.scrollView.delegate = self;
    // sscrollview edge to view
    
    self.pageControl.numberOfPages = 3;
    NSLog(@"!!! %lu", (unsigned long)self.viewArray.count);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
