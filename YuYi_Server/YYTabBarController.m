
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//
#import "YYTabBarController.h"
// #import "UIImage+Common.h"
#import "YYTabBar.h"
#import "YYNavigationController.h"
#import "YYHomePageViewController.h"
#import "YYSciencesViewController.h"
#import "YYPatientsViewController.h"
#import "YYPersonalViewController.h"

#define kTabbarItemTag 100
@interface YYTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) YYTabBar *tabBarView;


@end

@implementation YYTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBarView = [YYTabBar initWithTabs:4 systemTabBarHeight:self.tabBar.bounds.size.height selected:^(NSUInteger index) {
        self.selectedIndex = index;
    }];
    [self setupMainContents];
    [self setValue:self.tabBarView forKey:@"tabBar"];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

- (void)setupMainContents {
    // 首页
    YYHomePageViewController *homeVC = [[YYHomePageViewController alloc] init];
    [self addChildViewControllerAtIndex:0 childViewController:homeVC title:@"首页" normalImage:@"information" selectedImage:@"information-selected"];
    
    // 学术圈
    YYSciencesViewController *measureVC = [[YYSciencesViewController alloc] init];
    [self addChildViewControllerAtIndex:1 childViewController:measureVC title:@"学术圈" normalImage:@"Academiccircles" selectedImage:@"Academiccircles-selected"];
    
    // 患者
    YYPatientsViewController *consultVC = [[YYPatientsViewController alloc] init];
    [self addChildViewControllerAtIndex:2 childViewController:consultVC title:@"患者" normalImage:@"patient" selectedImage:@"patient-selected"];
    
    // 我的
    YYPersonalViewController *personalVC = [[YYPersonalViewController alloc] init];
    [self addChildViewControllerAtIndex:3 childViewController:personalVC title:@"我的" normalImage:@"my" selectedImage:@"my-selected"];
}

/**
 *  Add a child view controller.
 *
 *  @param index                index of the child Controller
 *  @param childViewController  child Controller
 *  @param title                title for item within TabBar
 *  @param normalImage          unselected image for item within TabBar
 *  @param selectedImage        selected image for item within TabBar
 */
- (void)addChildViewControllerAtIndex:(NSInteger)index childViewController:(UIViewController *)childViewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    // Set content of the corresponding tab bar item for child controller.
    
    [self.tabBarView setTabAtIndex:index title:title normalImage:normalImage selectedImage:selectedImage];
    
    // Add child Controller to TabBarController.
    YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:childViewController];
    [self addChildViewController:navigationVc];
}

#pragma mark - Actions.
- (void)switchTab:(NSUInteger)index {
    self.selectedIndex = index;
    [self.tabBarView selectTab:index];
}

@end
