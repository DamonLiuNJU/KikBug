//
//  KBReportManager.h
//  KikBug
//
//  Created by DamonLiu on 16/3/21.
//  Copyright © 2016年 DamonLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNAsset.h"

@interface KBBugReportItem : KBBaseModel
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *descForImage;
@end

@interface KBBugReport : KBBaseModel
@property (strong,nonatomic) NSArray<KBBugReportItem *> *items;/*< 1~9 个item **/

+ (instancetype)reportWithDNAssets:(NSArray<DNAsset *> *)list;
@end


@interface KBReportManager : NSObject

+ (void)uploadBugReport:(KBBugReport *)bugReport withCompletion:(void(^)(KBBaseModel *model,NSError *error))block;

@end

