//
//  KBReportmanager.m
//  KikBug
//
//  Created by DamonLiu on 16/3/21.
//  Copyright © 2016年 DamonLiu. All rights reserved.
//

#import "KBHttpManager.h"
#import "KBReportData.h"
#import "KBReportManager.h"
#import "KBImageManager.h"
#import "KBBugReport.h"

//@implementation KBBugReportItem
//
////
//
//@end


@interface KBReportManager ()

@end

static NSInteger REPORT_ID = -1;

@implementation KBReportManager

/**
 *  上传bug报告
 *
 *  @param bugReport bugReport description
 *  @param block     block description
 */
+ (void)uploadBugReport:(KBBugReport*)bugReport withCompletion:(void (^)(KBBaseModel*, NSError*))block
{
    NSString* url = GETURL_V2(@"UploadBug");
//    REPORT_ID = 10086;//test
    if (REPORT_ID >= 0) {
        bugReport.reportId = REPORT_ID;
    }
    else { //如果没有reportId，那么说明服务器没有返回reportId，不可以发送bug报告。
        return;
    }
    [KBHttpManager sendPostHttpRequestWithUrl:url Params:[bugReport mj_keyValues] CallBack:^(id responseObject, NSError* error) {
        if (!error) {
            bugReport.bugId = [responseObject integerValue];
        }
        else {
//            BugReport *report_model = [BugReport reportWithKBBugReport:bugReport];
//            [report_model saveToCoreData];
        }
    }];
}

+ (void)uploadTaskReport:(KBTaskReport*)taskReport withCompletion:(void (^)(KBBaseModel*, NSError*))block
{
    NSString* url = GETURL_V2(@"UploadTaskReport");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[taskReport mj_keyValues]];
    [KBHttpManager sendPostHttpRequestWithUrl:url Params:params CallBack:^(id responseObject, NSError* error) {
        if (!error) {
            NSInteger i_reportId = [responseObject integerValue];
            REPORT_ID = i_reportId;
            block(nil,nil);
        }
        else {
            block(nil,error);
        }
    }];
}

@end
