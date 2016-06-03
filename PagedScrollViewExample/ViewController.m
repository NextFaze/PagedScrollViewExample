//
//  ViewController.m
//  PagedScrollViewExample
//
//  Created by Ricardo Santos on 3/06/2016.
//  Copyright © 2016 NextFaze. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FrameAdjustments.h"

#define SCROLL_PAGE_WIDTH 200
#define SCROLL_PAGE_GAP 20

#define SCROLL_NUMBER_PAGES 5

@interface ClipView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation ClipView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self pointInside:point withEvent:event] ? self.scrollView : nil;
}

@end

#pragma ViewController

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollViewWithClipping;
@property (nonatomic, strong) UIScrollView *scrollViewWithoutClipping;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat scrollViewHeight = floorf(self.view.height/3.0);
    CGFloat scrollViewWidth = SCROLL_PAGE_WIDTH + SCROLL_PAGE_GAP;
    
    self.scrollViewWithClipping = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, scrollViewWidth, scrollViewHeight)];
    self.scrollViewWithClipping.top = floorf(scrollViewHeight/3.0);
    self.scrollViewWithClipping.centerX = self.view.width/2.0;
    self.scrollViewWithClipping.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    self.scrollViewWithClipping.pagingEnabled = YES;
    self.scrollViewWithClipping.clipsToBounds = NO;
    [self.view addSubview:self.scrollViewWithClipping];
    
    ClipView *clipView = [[ClipView alloc] init];
    clipView.top = self.scrollViewWithClipping.top;
    clipView.width = self.view.width;
    clipView.height = self.scrollViewWithClipping.height;
    clipView.scrollView = self.scrollViewWithClipping;
    [self.view insertSubview:clipView belowSubview:self.scrollViewWithClipping];
    
    self.scrollViewWithoutClipping = [[UIScrollView alloc] initWithFrame:self.scrollViewWithClipping.frame];
    self.scrollViewWithoutClipping.top = self.scrollViewWithClipping.bottom + floorf(scrollViewHeight/3.0);
    self.scrollViewWithoutClipping.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    self.scrollViewWithoutClipping.pagingEnabled = YES;
    self.scrollViewWithoutClipping.clipsToBounds = NO;
    [self.view addSubview:self.scrollViewWithoutClipping];
    
    NSArray *scrollViews = @[self.scrollViewWithClipping, self.scrollViewWithoutClipping];
    
    for (UIScrollView *scrollView in scrollViews) {
        
        CGRect pageFrame = CGRectMake(SCROLL_PAGE_GAP/2.0, 0, SCROLL_PAGE_WIDTH, scrollView.height);
        
        for (NSUInteger page = 0; page < SCROLL_NUMBER_PAGES; page++) {
            
            UIView *pageView = [[UIView alloc] initWithFrame:pageFrame];
            pageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            
            UILabel *label = [[UILabel alloc] initWithFrame:pageView.bounds];
            label.text = [NSString stringWithFormat:@"Page %lu", (page + 1)];
            label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightThin];
            [label sizeToFit];
            label.centerX = pageView.width/2.0;
            label.centerY = pageView.height/2.0;
            [pageView addSubview:label];
            
            [scrollView addSubview:pageView];
            
            pageFrame.origin.x += SCROLL_PAGE_GAP + SCROLL_PAGE_WIDTH;
        }
        
        scrollView.contentSize = CGSizeMake(pageFrame.origin.x, scrollView.height);
    }
}

@end
