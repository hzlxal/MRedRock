//
//  QueryViewController.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "QueryViewController.h"
#import "PlayViewController.h"
#import "HotListCell.h"
#import "Interface.h"

@interface QueryViewController ()
{
    NSString *_path;
    NSMutableArray *_arrPlayList;
    
    NSMutableArray *_arrQuerySong;
}

@end

@implementation QueryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"查询歌曲"];
    
    self.tableViewQuery.rowHeight = 80;
    
    _arrQuerySong = [[NSMutableArray alloc] init];
    

    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [searchPath objectAtIndex:0];
    _path = [documentDirectory stringByAppendingPathComponent:@"PlayList.plist"];
    [self readDataFromSandbox:_path];
}

- (void)readDataFromSandbox:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        _arrPlayList = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        _arrPlayList = [[NSMutableArray alloc] init];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrQuerySong.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotListCell";
    
    HotListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HotListCell" owner:nil options:nil] lastObject];
    }
    
    cell.btnPlay.tag = indexPath.row;
    [cell.btnPlay addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dictJson = _arrQuerySong[indexPath.row];
    
    return cell;
}

- (void)playAction:(UIButton *)sender
{
    [_arrPlayList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![_arrPlayList[idx][@"songid"] isEqualToString:_arrQuerySong[sender.tag][@"songid"]]) {
            [_arrPlayList addObject:_arrQuerySong[sender.tag]];
            [_arrPlayList writeToFile:_path atomically:YES];
            
            *stop = YES;
        }
    }];
    
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.dictJson = _arrQuerySong[sender.tag];
    [self.navigationController pushViewController:playViewController animated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
            [Interface querySong:searchBar.text resultBlock:^(id result) {
            [self hideLoadingView];
            
            [_arrQuerySong removeAllObjects];
            [_arrQuerySong addObjectsFromArray:result[@"showapi_res_body"][@"pagebean"][@"contentlist"]];
            [self.tableViewQuery reloadData];
        }];
        
        [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
