//
//  KBMyTaskListViewController.m
//  KikBug
//
//  Created by DamonLiu on 16/1/8.
//  Copyright © 2016年 DamonLiu. All rights reserved.
//

#import "KBHttpManager.h"
#import "KBMyTaskListViewController.h"
#import "KBTaskCellTableViewCell.h"
#import "KBTaskDetailViewController.h"
#import "KBTaskListModel.h"

@interface KBMyTaskListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray<KBTaskListModel*>* dataSourceForMyTasks;
@property (strong, nonatomic) NSArray<KBTaskListModel*>* dataSourceForGroup;
@property (strong, nonatomic) NSDictionary* dataSourceDic;
@property (strong, nonatomic) UISegmentedControl* segmentedControl;
@property (strong, nonatomic) NSArray<KBTaskListModel*>* dataSource;
@end

@implementation KBMyTaskListViewController

static NSString* identifier = @"KBMyTaskListViewController";

- (void)viewDidLoad
{
    [self setTitle:@"我的任务"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];

    self.dataSourceForGroup = [NSArray array];
    self.dataSourceForMyTasks = [NSArray array];
    self.dataSourceDic = @{ @(0) : self.dataSourceForMyTasks,
        @(1) : self.dataSourceForGroup };
    self.dataSource = [NSArray array];

    [self configSegmentControl];
    [self configTableView];
    [self configConstrains];
    [self loadData];
    [self addObserver:self forKeyPath:@"self.segmentedControl.selectedSegmentIndex" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    NSInteger newIndex = self.segmentedControl.selectedSegmentIndex;
    self.dataSource = self.dataSourceDic[@(newIndex)];
    [self.tableView reloadData];
}

- (void)loadData
{
    [KBHttpManager sendGetHttpReqeustWithUrl:GETURL(@"taskListUrl") Params:nil CallBack:^(id responseObject, NSError* error) {
        if (responseObject && !error) {
            NSDictionary* dic = (NSDictionary*)responseObject;
            NSArray* datas = dic[@"tasks"];
            NSMutableArray* tmpArary = [NSMutableArray array];
            for (id tmp in datas) {
                KBTaskListModel* model = [KBTaskListModel mj_objectWithKeyValues:tmp];
                [tmpArary addObject:model];
            }

            self.dataSourceForGroup = tmpArary;
            self.dataSourceDic = @{ @(0) : self.dataSourceForMyTasks,
                @(1) : self.dataSourceForGroup };
            self.dataSource = self.dataSourceForMyTasks;
            [self.tableView reloadData];
        }
        else {
            [self showLoadingViewWithText:@"网络错误，请重新刷新"];
        }
        [self hideLoadingView];
    }];
}

- (void)configSegmentControl
{
    NSArray* segmentedArray = [NSArray arrayWithObjects:@"我接受的", @"来自群组", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 150, 20.0f);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:segmentedControl];
    self.segmentedControl = segmentedControl;
}

- (void)configTableView
{
    self.tableView = [UITableView new];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[KBTaskCellTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)configConstrains
{
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-BOTTOM_BAR_HEIGHT];
}

#pragma mark - TableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    KBTaskCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[KBTaskCellTableViewCell class]]) {
        [cell fillWithContent:self.dataSource[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [KBTaskCellTableViewCell cellHeight];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //    KBTaskDetailViewController* detailVC = [[KBTaskDetailViewController alloc]initWithNibName:@"KBTaskDetailViewController" bundle:nil];
    [self showLoadingView];
    KBTaskDetailViewController* detailVC = (KBTaskDetailViewController*)[[HHRouter shared] matchController:TASK_DETAIL];
    [detailVC fillWithContent:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self hideLoadingView];
}

@end
