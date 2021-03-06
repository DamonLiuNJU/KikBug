//
//  KBBaseTableViewController.h
//  KikBug
//
//  Created by DamonLiu on 16/3/9.
//  Copyright © 2016年 DamonLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBBaseTableViewController : KBViewController<UITableViewDataSource,UITableViewDelegate>
- (void)configTableView;
+ (void)configHeaderStyle:(UITableView *)tableView;
- (void)endRefreshing;

- (void)showEmptyView;
- (void)showEmptyViewWithText:(NSString *)text;
- (void)showErrorView;
- (void)removeEmptyView;
@end
