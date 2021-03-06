//
//  KBTaskCellTableViewCell.m
//  KikBug
//
//  Created by DamonLiu on 15/8/11.
//  Copyright (c) 2015年 DamonLiu. All rights reserved.
//

#import "KBOnePixelLine.h"
#import "KBTaskCellTableViewCell.h"
#import "KBTaskListModel.h"
#import "NSString+EasyUse.h"
#import "NSString+Safe.h"
#import "SDWebImageManager.h"
#import "UIImageView+EaseUse.h"
@interface KBTaskCellTableViewCell ()
@property (strong, nonatomic) UIImageView* appImage;
@property (strong, nonatomic) UILabel* taskId;
@property (strong, nonatomic) UILabel* deadLine;
@property (strong, nonatomic) UILabel* taskName;
@property (strong, nonatomic) UILabel* taskDeadLineHintLabel; /**< 固定文本：到期时间 */
@property (strong, nonatomic) KBOnePixelLine* line;
@property (strong, nonatomic) UILabel* categoryLabel;
@end

@implementation KBTaskCellTableViewCell {
    UIImage* defaultImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self                         = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.appImage                    = [UIImageView new];
    self.appImage.layer.cornerRadius = 5.0f;
    self.appImage.clipsToBounds      = YES;
    self.appImage.contentMode        = UIViewContentModeScaleAspectFit;
    self.taskId                      = [UILabel new];
    self.deadLine                    = [UILabel new];
    self.taskName                    = [UILabel new];
    self.taskDeadLineHintLabel       = [UILabel new];
        [self.taskDeadLineHintLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"到期时间"
                                                                                      attributes:SUBTITLE_ATTRIBUTE]];
        [self.taskDeadLineHintLabel sizeToFit];
    self.line                        = [[KBOnePixelLine alloc] init];
        [self.line setLineColor:LIGHT_GRAY_COLOR];

    self.categoryLabel               = [UILabel new];
        [self configSubViews];
    }
    return self;
}

- (void)configConstrains
{
    [self.appImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8, 8, 8, 8) excludingEdge:ALEdgeRight];
    //    [self.appImage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.appImage];
    [self.appImage autoSetDimensionsToSize:CGSizeMake(50, 50)];

    [self.taskId autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.appImage withOffset:5];
    [self.taskId autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];

    [self.taskName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.taskId withOffset:5];
    [self.taskName autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.taskId];

    [self.taskDeadLineHintLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.deadLine withOffset:-5];
    [self.taskDeadLineHintLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.taskName];
    //    [self.taskDeadLineHintLabel autoPinEdgeToSuperviewMargin:ALEdgeRight];
//    [self.taskDeadLineHintLabel autoAlignAxis:ALAxisFirstBaseline toSameAxisOfView:self.taskName];

    //    [self.deadLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.taskDeadLineHintLabel withOffset:SMALL_MARGIN];
    [self.deadLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8.0];
    [self.deadLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.taskDeadLineHintLabel];

    //    [self.line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.line autoSetDimension:ALDimensionHeight toSize:1.0f];
    [self.line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 0) excludingEdge:ALEdgeTop];

//    [self.categoryLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line];
    [self.categoryLabel autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.appImage];
    [self.categoryLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.taskId];
    [super updateConstraints];
}

- (void)configSubViews
{
    [self layoutSubviews];
    self.appImage.contentMode        = UIViewContentModeScaleAspectFit;
    defaultImage                     = [UIImage imageNamed:@"appicon@2x.jpg"];

    [self addSubview:self.line];
    [self addSubview:self.taskDeadLineHintLabel];
    [self addSubview:self.appImage];
    [self addSubview:self.taskId];
    [self addSubview:self.taskName];
    [self addSubview:self.deadLine];
    [self addSubview:self.categoryLabel];
    [self configConstrains];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithContent:(KBTaskListModel*)data
{

    //    [self.taskId setText:data.taskId];
    [self.taskId setAttributedText:[[NSAttributedString alloc] initWithString:data.taskId
                                                                   attributes:SUBTITLE_ATTRIBUTE]];
    
    NSString* dateStr = [NSString simpleDateFromTimeStamp:data.taskDeadLine];
    [self.deadLine setAttributedText:[[NSAttributedString alloc] initWithString:dateStr
                                                                     attributes:SUBTITLE_ATTRIBUTE]];
    [self.taskName setAttributedText:[[NSAttributedString alloc] initWithString:data.taskName
                                                                     attributes:TITLE_ATTRIBUTE]];

    [self.categoryLabel setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"分类:%@",data.category]
                                                                     attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                   NSForegroundColorAttributeName : [UIColor grayColor] }]];

    if ([NSString isNilorEmpty:data.iconLocation]) {
    self.appImage.image              = defaultImage;
    }
    else {
        [self.appImage setImageWithUrl:data.iconLocation];
    }
}

+ (CGFloat)cellHeight
{
    return 65.0f;
}

@end
