//
//  HotListCell.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "HotListCell.h"
#import "UIImageView+WebCache.h"

@implementation HotListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgAlbum setImageWithURL:[NSURL URLWithString:_dictJson[@"albumpic_small"]] placeholderImage:[UIImage imageNamed:@"defaultPicture"]];
    self.lblSongName.text = _dictJson[@"songname"];
    self.lblSinger.text = _dictJson[@"singername"];
}

@end
