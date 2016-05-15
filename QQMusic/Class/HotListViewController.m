//
//  HotListViewController.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "HotListViewController.h"
#import "HotListCell.h"
#import "QueryViewController.h"
#import "PlayViewController.h"
#import "Interface.h"
#import "PlayListViewController.h"

@interface HotListViewController ()
{
    NSString *_path;
    NSMutableArray *_arrPlayList;
    
    NSMutableArray *_arrHotList;
}

@end

@implementation HotListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"热门榜单"];
    
    [self createLeftBarButtonItemWithImage:@"menu" withMethod:@selector(playListAction)];
    [self createRightBarButtonItemWithImage:@"search" withMethod:@selector(queryAction)];
    
    _arrHotList = [[NSMutableArray alloc] init];
    
    self.tableViewHotList.rowHeight = 80;
    

    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [searchPath objectAtIndex:0];
    _path = [documentDirectory stringByAppendingPathComponent:@"PlayList.plist"];
    [self readData:_path];
    
    [self getHotList];
}

- (void)readData:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        _arrPlayList = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        _arrPlayList = [[NSMutableArray alloc] init];
    }
}

- (void)playListAction
{
    [self.navigationController pushViewController:[[PlayListViewController alloc] init] animated:YES];
}

- (void)queryAction
{
    [self.navigationController pushViewController:[[QueryViewController alloc] init] animated:YES];
}

- (void)getHotList
{
            [Interface getHotList:@"5" resultBlock:^(id result) {
                [self hideLoadingView];
            
            [_arrHotList addObjectsFromArray:result[@"showapi_res_body"][@"pagebean"][@"songlist"]];
            [self.tableViewHotList reloadData];
        }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrHotList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotListCell";
    
    HotListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HotListCell" owner:nil options:nil] lastObject];
    }
    
    cell.btnPlay.tag = indexPath.row;
    [cell.btnPlay addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dictJson = _arrHotList[indexPath.row];
    
    return cell;
}

- (void)playAction:(UIButton *)sender
{
    if (_arrPlayList.count > 0) {
        NSMutableArray *arrSongId = [NSMutableArray array];
        for (int i = 0; i < _arrPlayList.count; i++) {
            [arrSongId addObject:[_arrPlayList[i][@"songid"] stringValue]];
        }
        
        if (![arrSongId containsObject:[_arrHotList[sender.tag][@"songid"] stringValue]]) {
            [_arrPlayList addObject:_arrHotList[sender.tag]];
            [_arrPlayList writeToFile:_path atomically:YES];
        }
    } else {
        [_arrPlayList addObject:_arrHotList[sender.tag]];
        [_arrPlayList writeToFile:_path atomically:YES];
    }
    
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.dictJson = _arrHotList[sender.tag];
    [self.navigationController pushViewController:playViewController animated:YES];
}

@end
