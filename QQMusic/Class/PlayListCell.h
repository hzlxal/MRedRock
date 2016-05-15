//
//  PlayListCell.h
//  QQMusic
//
//  Created by jiaojiao on 5/15/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblSinger;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) NSDictionary *dictJson;

@end
