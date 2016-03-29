//
//  KBUserAvatarCell.m
//  KikBug
//
//  Created by DamonLiu on 16/3/29.
//  Copyright © 2016年 DamonLiu. All rights reserved.
//

#import "KBUserAvatarCell.h"
#import "KBUserInfoManager.h"
#import "KBUserInfoModel.h"

@interface KBUserAvatarCell ()
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIImageView *avatar;
@end

@implementation KBUserAvatarCell

- (void)configSubviews
{
    [super configSubviews];
    UILabel *label = [UILabel new];
    label.text = @"头像";
    [self addSubview:label];
    self.label = label;
    
    self.avatar = [UIImageView new];
    [self addSubview:self.avatar];
    
    [self.rightArrow setHidden:NO];
}

-(void)configConstrains
{
    [super configConstrains];
    [self.label autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [self.label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.avatar autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightArrow withOffset:- 10.0f];
//    [self.avatar autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.avatar autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.avatar autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.avatar autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeWidth ofView:self.avatar];
    
    [super updateConstraints];
}

- (void)bindModel:(KBUserInfoModel *)model
{
    [self.avatar setImageWithUrl:model.avatarLocation];
}

@end
