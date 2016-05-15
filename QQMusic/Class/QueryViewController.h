//
//  QueryViewController.h
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewQuery;

@end
