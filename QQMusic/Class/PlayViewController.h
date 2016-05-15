//
//  PlayViewController.h
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    AVPlayer *_player; // 播放器对象
    
    BOOL _isPlaying; // 是否正在播放
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewPlayList;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlbumPicture;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderMusic;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *playSequenceButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@property (strong, nonatomic) NSDictionary *dictJson;

- (IBAction)btnPlay:(UIButton *)sender;
- (IBAction)btnPreMusic;
- (IBAction)btnNextMusic;
- (IBAction)changeMusicProgress:(UISlider *)sender;
- (IBAction)btnSelectPlaySequence;
- (IBAction)btnPlayList;
- (IBAction)btnClose;

@end
