//
//  PlayListViewController.m
//  QQMusic
//
//  Created by jiaojiao on 5/15/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayListCell.h"
#import "PlayViewController.h"

@interface PlayListViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *_arrPlayList;
    NSString *_path;
    
    NSInteger _index;
}

@end

@implementation PlayListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"播放列表"];
    
    self.tableViewPlayList.rowHeight = 80;
        
    [self readDataFromSandbox];
}

- (void)readDataFromSandbox
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
    
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要将该歌曲从播放列表中删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.dictJson = _arrPlayList[indexPath.row];
    [self.navigationController pushViewController:playViewController animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [_arrPlayList removeObjectAtIndex:_index];
        [self.tableViewPlayList reloadData];
        
        [_arrPlayList writeToFile:_path atomically:YES];
    }
}

@end
