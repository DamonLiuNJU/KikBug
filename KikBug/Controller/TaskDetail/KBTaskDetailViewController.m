//
//  KBTaskDetailViewController.m
//  KikBug
//
//  Created by DamonLiu on 15/8/11.
//  Copyright (c) 2015年 DamonLiu. All rights reserved.
//

#import "AFNetworking.h"
#import "DNImagePickerController.h"
#import "KBBaseModel.h"
#import "KBBugManager.h"
#import "KBBugReport.h"
#import "KBHttpManager.h"
#import "KBImageManager.h"
#import "KBOnePixelLine.h"
#import "KBReportData.h"
#import "KBReportManager.h"
#import "KBTaskDetailModel.h"
#import "KBTaskDetailViewController.h"
#import "KBTaskListModel.h"
#import "KBTaskManager.h"
#import "KBUserHomeViewController.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+EaseUse.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+DNImagePicker.h"

@interface KBTaskDetailViewController ()

//@property (strong, nonatomic) KBTaskListModel* model;
@property (strong, nonatomic) KBTaskDetailModel* detailModel;
@property (strong, nonatomic) MBProgressHUD* hud;

@property (strong, nonatomic) UITextView* taskDescription;
@property (strong, nonatomic) UILabel* taskDescriptionHint;
@property (strong, nonatomic) UILabel* taskIdLabel;
@property (strong, nonatomic) UILabel* taskIdLabelHint;
@property (strong, nonatomic) UILabel* pointsLabel;
@property (strong, nonatomic) UILabel* pointsHintLbale;
@property (strong, nonatomic) UILabel* categoryLabel;
@property (strong, nonatomic) UILabel* categoryLabelHint;
@property (strong, nonatomic) UILabel* addDateLabel;
@property (strong, nonatomic) UILabel* addDateLabelHint;
@property (strong, nonatomic) UILabel* dueDateLabel;
@property (strong, nonatomic) UILabel* dueDateLabelHint;
@property (strong, nonatomic) UIImageView* icon;
//@property (strong, nonatomic) UIButton* jumpButton;
@property (strong, nonatomic) UIButton* acceptTask;
@property (strong, nonatomic) KBOnePixelLine* line;

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView* containerView;
@property (strong, nonatomic) UIButton* goToMyReportsBtn; /**< 跳转到我的Bug报告页面 */
@property (strong, nonatomic) UIButton* addBugReportBtn;
@property (strong, nonatomic) UIButton* startTestTask;

@property (strong, nonatomic) UIButton* installBtn;

@property (assign, nonatomic) BOOL isTaskAccepted;
@property (copy, nonatomic) NSString* taskId;

@property (strong, nonatomic) UILabel* taskNameHintLabel;
@property (strong, nonatomic) UILabel* taskNameLabel;

@property (strong,nonatomic) KBOnePixelLine *lineUnderAppIcon;

@end

@implementation KBTaskDetailViewController {
    NSURL* appUrl;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createSubviews];
        self.isTaskAccepted = NO;
        [self addObserver:self forKeyPath:@"isTaskAccepted" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self showLoadingView];
    //    [self createSubviews];
    [self configSubviews];
    [self configNavigationBar];
    UISwipeGestureRecognizer* rec = [[UISwipeGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(backToPreviousPage)];
    [rec setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rec];

    self.goToMyReportsBtn.hidden = !self.acceptTask.hidden;
//    self.startTestTask.hidden = !self.acceptTask.hidden;
//    self.installBtn.hidden = self.startTestTask.hidden;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
//    self.acceptTask.hidden = !self.isTaskAccepted;
    self.goToMyReportsBtn.hidden = !self.isTaskAccepted;
//    self.startTestTask.hidden = !self.isTaskAccepted;
//    self.installBtn.hidden = !self.isTaskAccepted;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isTaskAccepted"];
}

- (void)createSubviews
{
    self.startTestTask = [UIButton new];
    self.taskDescription = [UITextView new];
    self.taskDescriptionHint = [UILabel new];
    self.taskIdLabelHint = [UILabel new];
    self.taskIdLabel = [UILabel new];
    self.pointsLabel = [UILabel new];
    self.pointsHintLbale = [UILabel new];
    self.categoryLabelHint = [UILabel new];
    self.categoryLabel = [UILabel new];
    self.addDateLabelHint = [UILabel new];
    self.addDateLabel = [UILabel new];
    self.dueDateLabelHint = [UILabel new];
    self.dueDateLabel = [UILabel new];
    self.icon = [UIImageView new];
    self.icon.layer.cornerRadius = 5.0f;
    self.icon.clipsToBounds = YES;
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
//        self.jumpButton = [UIButton new];
    self.acceptTask = [UIButton new];
    self.containerView = [UIView new];
    self.goToMyReportsBtn = [UIButton new];
    self.scrollView = [UIScrollView new];
    self.installBtn = [UIButton new];
    
    self.lineUnderAppIcon = [[KBOnePixelLine alloc] initWithFrame:CGRectZero];
    [self.lineUnderAppIcon setLineColor:LIGHT_GRAY_COLOR];
    self.line = [[KBOnePixelLine alloc] initWithFrame:CGRectZero];
    [self.line setLineColor:LIGHT_GRAY_COLOR];

    self.taskNameLabel = [UILabel new];
    self.taskNameHintLabel = [UILabel new];
    
    //审核
    self.pointsLabel.hidden = YES;
    self.pointsHintLbale.hidden = YES;
    self.installBtn.hidden = YES;
    self.startTestTask.hidden = YES;
}

- (void)configSubviews
{
    [self.startTestTask addTarget:self action:@selector(startTaskButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.goToMyReportsBtn addTarget:self action:@selector(checkMyReportsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //    [self.jumpButton addTarget:self action:@selector(jumpToApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.taskDescription setEditable:NO];
    [self.installBtn addTarget:self action:@selector(installAppBtnPressed) forControlEvents:UIControlEventTouchUpInside];
#if DEBUG
//    [self.taskDescription setBackgroundColor:[UIColor lightGrayColor]];
#endif
    [self.acceptTask
        setAttributedTitle:[[NSAttributedString alloc]
                               initWithString:@"接受任务"
                                   attributes:@{ NSFontAttributeName : APP_FONT(12),
                                       NSForegroundColorAttributeName : THEME_COLOR }]
                  forState:UIControlStateNormal];
    [self.acceptTask setBackgroundColor:[UIColor whiteColor]];
    self.acceptTask.layer.cornerRadius = 3.0f;
    [self.acceptTask addTarget:self action:@selector(acceptTaskButtonPressed) forControlEvents:UIControlEventTouchUpInside];

   
    [self.taskIdLabelHint setAttributedText:[[NSAttributedString alloc]
                                                initWithString:@"任务Id"
                                                    attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                        NSForegroundColorAttributeName : [UIColor grayColor] }]];
    [self.pointsHintLbale
        setAttributedText:[[NSAttributedString alloc]
                              initWithString:@"分数"
                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor grayColor] }]];
    [self.categoryLabelHint
        setAttributedText:[[NSAttributedString alloc]
                              initWithString:@"分类"
                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor grayColor] }]];
    [self.addDateLabelHint
        setAttributedText:[[NSAttributedString alloc]
                              initWithString:@"添加日期"
                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor grayColor] }]];
    [self.dueDateLabelHint
        setAttributedText:[[NSAttributedString alloc]
                              initWithString:@"到期日期"
                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor grayColor] }]];

    [self.taskNameHintLabel
        setAttributedText:[[NSAttributedString alloc]
                              initWithString:@"任务名称"
                                  attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                      NSForegroundColorAttributeName : [UIColor grayColor] }]];

    [self.goToMyReportsBtn setAttributedTitle:[[NSAttributedString alloc]
                                                  initWithString:@"查看任务报告"
                                                      attributes:BUTTON_TITLE_ATTRIBUTE]
                                     forState:UIControlStateNormal];

    [self.taskDescriptionHint setAttributedText:[[NSAttributedString alloc]
                                                    initWithString:@"任务描述"
                                                        attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName : [UIColor grayColor] }]];

    [self.goToMyReportsBtn setBackgroundColor:[KBUIConstant themeDarkColor]];
    [self.goToMyReportsBtn.layer setCornerRadius:5.0f];
    [self.startTestTask setBackgroundColor:[KBUIConstant themeDarkColor]];
    [self.startTestTask.layer setCornerRadius:5.0f];
    [self.installBtn setBackgroundColor:[KBUIConstant themeDarkColor]];
    [self.installBtn.layer setCornerRadius:5.0f];

    [self.startTestTask setAttributedTitle:[[NSAttributedString alloc]
                                               initWithString:@"开始任务"
                                                   attributes:BUTTON_TITLE_ATTRIBUTE]
                                  forState:UIControlStateNormal];

    [self.installBtn setAttributedTitle:[[NSAttributedString alloc]
                                            initWithString:@"安装"
                                                attributes:BUTTON_TITLE_ATTRIBUTE]
                               forState:UIControlStateNormal];

    [self.view addSubview:self.pointsHintLbale];
    [self.view addSubview:self.pointsLabel];
    [self.view addSubview:self.categoryLabelHint];
    [self.view addSubview:self.categoryLabel];
    [self.view addSubview:self.addDateLabelHint];
    [self.view addSubview:self.addDateLabel];
    [self.view addSubview:self.dueDateLabelHint];
    [self.view addSubview:self.dueDateLabel];
    [self.view addSubview:self.taskIdLabel];
    [self.view addSubview:self.taskIdLabelHint];
    [self.view addSubview:self.icon];

    [self.view addSubview:self.taskNameLabel];
    [self.view addSubview:self.taskNameHintLabel];

    //    [self.view addSubview:self.jumpButton];
    [self.view addSubview:self.line];
    [self.view addSubview:self.lineUnderAppIcon];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];

    [self.containerView addSubview:self.goToMyReportsBtn];
    [self.containerView addSubview:self.taskDescriptionHint];
    [self.containerView addSubview:self.taskDescription];
    [self.containerView addSubview:self.startTestTask];
    [self.containerView addSubview:self.installBtn];
}

- (void)configConstrains
{
    [self.icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
    [self.icon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.icon autoSetDimension:ALDimensionWidth toSize:60];
    [self.icon autoSetDimension:ALDimensionHeight toSize:60];

    //    [self.jumpButton autoPinEdge:ALEdgeTop
    //                          toEdge:ALEdgeBottom
    //                          ofView:self.icon
    //                      withOffset:5.0f];
    //    [self.jumpButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.icon];
    //    [self.jumpButton autoSetDimensionsToSize:CGSizeMake(60, 20)];

    [self.taskIdLabelHint autoPinEdge:ALEdgeLeft
                               toEdge:ALEdgeRight
                               ofView:self.icon
                           withOffset:5.0f];
    [self.taskIdLabelHint autoPinEdge:ALEdgeTop
                               toEdge:ALEdgeBottom
                               ofView:self.taskNameHintLabel
                           withOffset:5.0f];

    [self.taskIdLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeLeft
                           ofView:self.taskNameLabel];

    [self.taskIdLabel autoPinEdge:ALEdgeBottom
                           toEdge:ALEdgeBottom
                           ofView:self.taskIdLabelHint];

//    [self.pointsHintLbale autoPinEdge:ALEdgeLeft
//                               toEdge:ALEdgeRight
//                               ofView:self.icon
//                           withOffset:5.0f];
//
//    [self.pointsHintLbale autoPinEdge:ALEdgeTop
//                               toEdge:ALEdgeBottom
//                               ofView:self.taskIdLabelHint
//                           withOffset:5];
//
//    [self.pointsLabel autoPinEdge:ALEdgeLeft
//                           toEdge:ALEdgeLeft
//                           ofView:self.taskNameLabel];
//
//    [self.pointsLabel autoPinEdge:ALEdgeBottom
//                           toEdge:ALEdgeBottom
//                           ofView:self.pointsHintLbale];
    
    [self.categoryLabelHint autoPinEdge:ALEdgeLeft
                               toEdge:ALEdgeRight
                               ofView:self.icon
                           withOffset:5.0f];

    [self.categoryLabelHint autoPinEdge:ALEdgeTop
                               toEdge:ALEdgeBottom
                               ofView:self.taskIdLabelHint
                           withOffset:5];

    [self.categoryLabel autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeLeft
                           ofView:self.taskNameLabel];

    [self.categoryLabel autoPinEdge:ALEdgeBottom
                           toEdge:ALEdgeBottom
                           ofView:self.categoryLabelHint];

//    [self.categoryLabelHint autoPinEdge:ALEdgeLeft
//                                 toEdge:ALEdgeRight
//                                 ofView:self.icon
//                             withOffset:5.0f];
//    [self.categoryLabelHint autoPinEdge:ALEdgeTop
//                                 toEdge:ALEdgeBottom
//                                 ofView:self.pointsHintLbale
//                             withOffset:5];
//
//    [self.categoryLabel autoPinEdge:ALEdgeLeft
//                             toEdge:ALEdgeLeft
//                             ofView:self.taskNameLabel];
//
//    [self.categoryLabel autoPinEdge:ALEdgeBottom
//                             toEdge:ALEdgeBottom
//                             ofView:self.categoryLabelHint];

    [self.addDateLabelHint autoPinEdgeToSuperviewMargin:ALEdgeLeft];

    [self.addDateLabelHint autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.lineUnderAppIcon
                            withOffset:5];

    [self.addDateLabel autoPinEdge:ALEdgeLeft
                            toEdge:ALEdgeRight
                            ofView:self.addDateLabelHint
                        withOffset:5.0f];
    
    [self.addDateLabel autoPinEdge:ALEdgeBottom
                            toEdge:ALEdgeBottom
                            ofView:self.addDateLabelHint];

    [self.dueDateLabelHint autoPinEdge:ALEdgeLeft
                                toEdge:ALEdgeLeft
                                ofView:self.addDateLabelHint];
    
    [self.dueDateLabelHint autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.addDateLabelHint
                            withOffset:5];

    [self.dueDateLabel autoPinEdge:ALEdgeLeft
                            toEdge:ALEdgeRight
                            ofView:self.dueDateLabelHint
                        withOffset:5.0f];
    [self.dueDateLabel autoPinEdge:ALEdgeBottom
                            toEdge:ALEdgeBottom
                            ofView:self.dueDateLabelHint];

    [self.taskNameHintLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:5.0f];
    [self.taskNameHintLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.icon];

    [self.taskNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.taskNameHintLabel withOffset:5.0f];
    [self.taskNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.taskNameHintLabel];

    [self.taskDescriptionHint autoPinEdgeToSuperviewEdge:ALEdgeTop];

    [self.taskDescriptionHint autoPinEdgeToSuperviewMargin:ALEdgeLeft];

    [self.lineUnderAppIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.icon withOffset:5.0f];
    [self.lineUnderAppIcon autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [self.lineUnderAppIcon autoPinEdgeToSuperviewMargin:ALEdgeRight];
    [self.lineUnderAppIcon autoSetDimension:ALDimensionHeight toSize:1.0f];
    
    [self.line autoPinEdge:ALEdgeTop
                    toEdge:ALEdgeBottom
                    ofView:self.dueDateLabel
                withOffset:5.0f];

    [self.line autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [self.line autoPinEdgeToSuperviewMargin:ALEdgeRight];
    [self.line autoSetDimension:ALDimensionHeight toSize:1.0f];

    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, BOTTOM_BAR_HEIGHT, 10)
                                 excludingEdge:ALEdgeTop];
    [self.scrollView autoPinEdge:ALEdgeTop
                          toEdge:ALEdgeBottom
                          ofView:self.line
                      withOffset:5.0f];

    //    [self.taskDescription autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.taskDescription autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.taskDescription autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.taskDescription autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.taskDescriptionHint];

    [self.startTestTask autoSetDimensionsToSize:CGSizeMake(120, 40)];
    [self.installBtn autoSetDimensionsToSize:CGSizeMake(120, 40)];
//    [self.goToMyReportsBtn autoSetDimensionsToSize:CGSizeMake(120, 40)];

    [self.goToMyReportsBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.taskDescription withOffset:5.0f];
    [self.startTestTask autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.taskDescription withOffset:5.0f];

    [self.startTestTask autoAlignAxis:ALAxisVertical toSameAxisOfView:self.containerView withOffset:-80];
//    [self.goToMyReportsBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:self.containerView withOffset:+80];

    [self.goToMyReportsBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.goToMyReportsBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
    [self.goToMyReportsBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [self.goToMyReportsBtn autoSetDimension:ALDimensionHeight toSize:40.0];
    
    [self.installBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:self.containerView withOffset:-80];
    [self.installBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.startTestTask withOffset:20.0f];

    [self.containerView autoPinEdgesToSuperviewEdges];

    [self.containerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.installBtn withOffset:5.0f];

    [super updateViewConstraints];
}

- (void)configNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self navigationRightButton];
    [self navigationLeftButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
}
- (void)navigationLeftButton
{
}
- (void)navigationRightButton
{
    [self.acceptTask setFrame:CGRectMake(0, 0, 60, 30)];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:self.acceptTask];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goToUserHome
{
    KBUserHomeViewController* vc = [KBUserHomeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    WEAKSELF;
    [KBTaskManager fetchTaskDetailInfoWithTaskId:self.taskId completion:^(KBTaskDetailModel* model, NSError* error) {
        weakSelf.detailModel = model;
        [weakSelf updateUIwithModel:model];
        [weakSelf hideLoadingView];
    }];
}

- (void)updateUIwithModel:(KBTaskDetailModel*)model
{

    self.taskDescription.attributedText = [[NSAttributedString alloc]
        initWithString:model.taskdescription ? model.taskdescription : @""
            attributes:TITLE_ATTRIBUTE];

    CGFloat heightForTaskDesc = [model.taskdescription heightForString:model.taskdescription fontSize:14 andWidth:self.scrollView.width];
    [self.taskDescription autoSetDimensionsToSize:CGSizeMake(self.scrollView.width, heightForTaskDesc)];
    [self updateViewConstraints];

    self.addDateLabel.attributedText = [[NSAttributedString alloc]
        initWithString:[NSString dateFromTimeStamp:model.addDate]
            attributes:TITLE_ATTRIBUTE];
    self.dueDateLabel.attributedText = [[NSAttributedString alloc]
        initWithString:[NSString dateFromTimeStamp:model.deadline]
            attributes:TITLE_ATTRIBUTE];
    self.taskIdLabel.attributedText = [[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%ld", (long)model.taskId]
            attributes:TITLE_ATTRIBUTE];
    self.pointsLabel.attributedText =
        [[NSAttributedString alloc] initWithString:INT_TO_STIRNG(model.points)
                                        attributes:TITLE_ATTRIBUTE];
    self.categoryLabel.attributedText =
        [[NSAttributedString alloc] initWithString:NSSTRING_NOT_NIL(model.category)
                                        attributes:TITLE_ATTRIBUTE];

    self.taskNameLabel.attributedText =
        [[NSAttributedString alloc] initWithString:model.taskName
                                        attributes:TITLE_ATTRIBUTE];

    [self.icon setImageWithUrl:model.iconLocation];
    [self markAcceptBtnAsAccepted:self.detailModel.hasTask];
}

- (void)backToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    self.detailModel = nil;
}

- (void)markAcceptBtnAsAccepted:(BOOL)bol
{
    [self.acceptTask setEnabled:!bol];
    self.isTaskAccepted = bol;
    [self.acceptTask
        setAttributedTitle:[[NSAttributedString alloc]
                               initWithString:bol ? @"已接受" : @"接受"
                                   attributes:@{ NSFontAttributeName : APP_FONT(12),
                                       NSForegroundColorAttributeName : THEME_COLOR }]
                  forState:UIControlStateNormal];
}

- (void)showLoadingView
{
    [self showLoadingViewWithText:TIP_LOADING];
}

- (void)hideLoadingView
{
    [self.hud hide:YES];
    [self hubShowInView].userInteractionEnabled = YES;
    self.hud = nil;
}

- (UIView*)hubShowInView
{
    UIView* inView = self.view;
    return inView;
}

#pragma mark - UI Events

- (void)acceptTaskButtonPressed
{
    WEAKSELF;
    [KBTaskManager acceptTaskWithTaskId:self.taskId completion:^(KBBaseModel* model, NSError* error) {
        //        NSLog(model.message);
        if (!error) {
            [weakSelf showLoadingViewWithText:@"任务添加成功" withDuration:2.0f];
        }
        else {
            NSString* errormsg = [NSString stringWithFormat:@"%@ (%@)", model.message, INT_TO_STIRNG(model.status)];
            [weakSelf showAlertViewWithText:errormsg];
        }
    }];
}

- (void)startTaskButtonPressed
{
    [self jumpToApp:nil];
}

/**
 *  发出开始测试的Scheme
 *
 *  @param sender sender description
 */
- (void)jumpToApp:(id)sender
{
    [self showAlertViewWithTitle:@"提示" Text:@"App将跳转到其他App，如未安装被任务所需App，则需要您先安装之"];
    NSString* host = self.detailModel.scheme;
#if DEBUG
    host = @"Airvin";
#endif
    NSString* str = [NSString stringWithFormat:@"%@://?taskId=%ld", host, (long)self.detailModel.taskId];
    appUrl = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:appUrl];
}

#pragma mark - UIEvent
- (void)checkMyReportsButtonPressed
{
    if ([KBReportManager getReportId] <= 0) {
        //不允许用户填写bug报告 因为测试报告上传失败了。
        KBTaskReport* report = [KBTaskReport fakeReport];
        report.taskId = self.detailModel.taskId;
        [KBReportManager uploadTaskReport:report withCompletion:^(KBBaseModel* model, NSError* error){
        }];
    }
    UIViewController* vc = [[HHRouter shared] matchController:MY_TASK_REPORT];
    [vc setParams:@{ @"taskId" : @(self.detailModel.taskId) }];
    [[KBNavigator sharedNavigator] showViewController:vc];
}

- (void)installAppBtnPressed
{
    [self showAlertViewWithTitle:@"提示" Text:@"App将跳转到AppStore，如未发生跳转，需要您自行前往AppStore进行App的安装"];
    //
    //    NSString* str = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", self.detailModel.appLocation];
//    NSString* str = self.detailModel.appLocation;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    NSString *url = self.detailModel.appLocation;
//    url = @"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8";
//    url = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?mt=8&id=286274367";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)setParams:(NSDictionary*)params
{
    self.taskId = params[@"taskId"];
}
@end
