//
//  HotListCell.h
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblSinger;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (strong, nonatomic) NSDictionary *dictJson;

@end
