//
//  BaseViewController.m
//  MedicationMate
//
//  Created by jiaojiao on 4/26/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()
{
    UIView *_loadingView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self createBackButton];
}

- (void)createBackButton
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)createLeftBarButtonItemWithTitle:(NSString *)title withMethod:(SEL)method
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:method];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)createLeftBarButtonItemWithImage:(NSString *)imageName withMethod:(SEL)method
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:method];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)createRightBarButtonItemWithTitle:(NSString *)title withMethod:(SEL)method
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:method];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)createRightBarButtonItemWithImage:(NSString *)imageName withMethod:(SEL)method
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:method];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _loadingView.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicatorView.frame = CGRectMake((kScreenWidth - 40) / 2, (kScreenHeight - 40) / 2, 40, 40);
        [activityIndicatorView startAnimating];
        [_loadingView addSubview:activityIndicatorView];
    }
    
    [self.navigationController.view addSubview:_loadingView];
}

- (void)hideLoadingView
{
    [_loadingView removeFromSuperview];
}

@end
