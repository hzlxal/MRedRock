//
//  BaseViewController.h
//  MedicationMate
//
//  Created by jiaojiao on 4/26/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController



- (void)createLeftBarButtonItemWithTitle:(NSString *)title withMethod:(SEL)method;

- (void)createLeftBarButtonItemWithImage:(NSString *)imageName withMethod:(SEL)method;

- (void)createRightBarButtonItemWithTitle:(NSString *)title withMethod:(SEL)method;

- (void)createRightBarButtonItemWithImage:(NSString *)imageName withMethod:(SEL)method;


- (void)loadingView;
- (void)hideLoadingView;

@end
