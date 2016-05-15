//
//  PlayListCell.m
//  QQMusic
//
//  Created by jiaojiao on 5/15/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "PlayListCell.h"

@implementation PlayListCell

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
    
    self.lblSongName.text = _dictJson[@"songname"];
    self.lblSinger.text = _dictJson[@"singername"];
}

@end
