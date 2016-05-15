//
//  PlayViewController.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "PlayViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayListCell.h"

@interface PlayViewController ()
{
    NSTimer *_timerMusic;

    NSArray *_arrTitle; // 播放顺序选择：顺序播放、随机播放、单曲循环、列表循环
    NSInteger _playMethod; // 播放方式：0:顺序播放 1:随机播放 2:单曲循环 3:列表循环
    
    NSMutableArray *_arrPlayList; // 播放列表
    NSString *_path;
    NSInteger _index;
    
    NSMutableArray *_arrMusciData; // 音乐数据
    NSInteger _currentIndex; // 当前播放歌曲的索引
}

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"播放歌曲"];
    
    self.tableViewPlayList.rowHeight = 80;
    
    [self initPlayListView];
    [self readData];
    
    [self initMusic];
}

- (void)readData
{
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [searchPath objectAtIndex:0];
    _path = [documentDirectory stringByAppendingPathComponent:@"PlayList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_path]) {
        _arrPlayList = [NSMutableArray arrayWithContentsOfFile:_path];
        [self.tableViewPlayList reloadData];
    }
}

- (void)initPlayListView
{
    self.closeButton.layer.borderWidth = 1.0;
    self.closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewBottomConstraint.constant = -500;
}

- (void)initMusic
{
    _arrTitle = @[@"顺序播放", @"随机播放", @"单曲循环", @"列表循环"];
    _playMethod = 0;
    
    _isPlaying = YES;
    self.playButton.selected = YES;
    for (int i = 0; i < _arrPlayList.count; i++) { // 找到当前播放的音乐的索引值
        if ([[_arrPlayList[i][@"songid"] stringValue] isEqualToString:[_dictJson[@"songid"] stringValue]]) {
            _currentIndex = i;
            break;
        }
    }
    
    [self setMusicData]; // 设置音乐相关信息
    
    // 每秒刷新一次时间
    _timerMusic = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showCurrentTime) userInfo:nil repeats:YES];
    [_timerMusic fire];
}

- (void)setMusicData
{
    self.lblName.text = [NSString stringWithFormat:@"%@ - %@", _arrPlayList[_currentIndex][@"singername"], _arrPlayList[_currentIndex][@"songname"]];
    [self.imgAlbumPicture setImageWithURL:[NSURL URLWithString:_arrPlayList[_currentIndex][@"albumpic_big"]] placeholderImage:[UIImage imageNamed:@"defaultPicture"]];
    
    // 设置开始播放时间和结束播放时间
    self.lblCurrentTime.text = @"00:00";
    self.lblEndTime.text = [NSString stringWithFormat:@"%.2d:%.2d", [_arrPlayList[_currentIndex][@"seconds"] intValue] / 60, [_arrPlayList[_currentIndex][@"seconds"] intValue] % 60];
    
    self.sliderMusic.value = 0.0; // 设置滑动条归零
    
    if (_player == nil) {
        // 创建播放器对象
        _player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_arrPlayList[_currentIndex][@"url"]]]];
    } else {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_arrPlayList[_currentIndex][@"url"]]];
        [_player replaceCurrentItemWithPlayerItem:item];
    }
    [_player play];
    
    [self.tableViewPlayList selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)btnPlay:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_isPlaying) {
        _isPlaying = NO;
        
        [_player pause];
    } else {
        _isPlaying = YES;
        
        [_player play];
    }
}

- (void)showCurrentTime
{
    // 设置当前时间
    long long currentTime = _player.currentItem.currentTime.value / _player.currentItem.currentTime.timescale;
    self.lblCurrentTime.text = [NSString stringWithFormat:@"%.2d:%.2d", (int)currentTime / 60, (int)currentTime % 60];
    
    // 设置当前滑动条的值
    self.sliderMusic.value = (float)currentTime / [_dictJson[@"seconds"] floatValue];
    
    if (currentTime == [_dictJson[@"seconds"] intValue]) {
        [self autoPlayNextMusic]; // 自动播放下一首歌曲
    }
}

//切换到上一首歌曲
- (IBAction)btnPreMusic {
    if (_playMethod == 1) { // 随机播放
        _currentIndex = arc4random_uniform((int)_arrPlayList.count);
        [self setMusicData];
    } else { // 顺序播放、单曲循环、列表循环
        if (_currentIndex - 1 >= 0) {
            _currentIndex--;
            
            [self setMusicData];
        } else {
            _currentIndex = _arrPlayList.count - 1;
            
            [self setMusicData];
        }
    }
}

//切换到下一首歌曲
- (IBAction)btnNextMusic {
    if (_playMethod == 1) { // 随机播放
        _currentIndex = arc4random_uniform((int)_arrPlayList.count);
        [self setMusicData];
    } else { // 顺序播放、单曲循环、列表循环
        if (_currentIndex + 1 < _arrPlayList.count) {
            _currentIndex++;
            
            [self setMusicData];
        } else {
            _currentIndex = 0;
            
            [self setMusicData];
        }
    }
}

- (IBAction)changeMusicProgress:(UISlider *)sender {
    //[_player seekToTime:CMTimeMake(sender.value, 1)];
}

//选择播放顺序
- (IBAction)btnSelectPlaySequence {
    _playMethod = ([_arrTitle indexOfObject:self.playSequenceButton.titleLabel.text] + 1) % _arrTitle.count;
    
    [self.playSequenceButton setTitle:_arrTitle[_playMethod] forState:UIControlStateNormal];
}

//自动播放下一首歌曲
- (void)autoPlayNextMusic
{
    switch (_playMethod) {
        case 0: // 顺序播放
        {
            if (_currentIndex == _arrPlayList.count - 1) {
                [_player pause];
                _player = nil;
            } else {
                _currentIndex++;
                [self setMusicData];
            }
        }
            break;
        case 1: // 随机播放
        {
            _currentIndex = arc4random_uniform((int)_arrPlayList.count);
            [self setMusicData];
        }
            break;
        case 2: // 单曲循环
        {
            [self setMusicData];
        }
            break;
        case 3: // 列表循环
        {
            _currentIndex = (_currentIndex + 1) % _arrPlayList.count;
            [self setMusicData];
        }
            break;
    }
}

- (IBAction)btnPlayList {
    self.viewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.275 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.tableViewPlayList selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)btnClose {
    self.viewBottomConstraint.constant = -500;
    
    [UIView animateWithDuration:0.275 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrPlayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlayListCell";
    
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlayListCell" owner:nil options:nil] lastObject];
        
        UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBgView.backgroundColor = kRGBColor(0, 202, 127);
        cell.selectedBackgroundView = selectedBgView;
    }
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dictJson = _arrPlayList[indexPath.row];
    
    return cell;
}

- (void)deleteAction:(UIButton *)sender
{
    _index = sender.tag;
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"您确定要将该歌曲从播放列表中删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex != indexPath.row) {
        _currentIndex = indexPath.row;
        
        [self setMusicData];
    }
    
    [self btnClose];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (_index == _currentIndex) {
            if (_playMethod == 1) { // 随机播放
                _currentIndex = arc4random_uniform((int)_arrPlayList.count);
                [self setMusicData];
            } else { // 顺序播放、单曲循环、列表循环
                if (_currentIndex + 1 < _arrPlayList.count) {
                    _currentIndex++;
                    
                    [self setMusicData];
                } else {
                    _currentIndex = 0;
                    
                    [self setMusicData];
                }
            }
        }
        
        [_arrPlayList removeObjectAtIndex:_index];
        [self.tableViewPlayList reloadData];
        
        [_arrPlayList writeToFile:_path atomically:YES];
    }
}

- (void)backAction
{
    [_player pause]; // 暂停播放
    _player = nil; // 清除AVPlayer对象
    
    [_timerMusic invalidate]; // 使定时器无效
    _timerMusic = nil; // 清除定时器
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
