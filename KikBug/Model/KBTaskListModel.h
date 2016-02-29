//
//  KBTaskListModel.h
//  KikBug
//
//  Created by DamonLiu on 15/11/9.
//  Copyright © 2015年 DamonLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"
#import "Macros.h"


//{\"id\":1,\"iconLocation\":null,\"name\":\"测试\",\"createDate\":1456418438,\"endDate\":1456418438,\"description\":\"测试\",\"points\":3}

@interface KBTaskListModel : NSObject<MJKeyValue>
JSONSTIRNG taskId;
JSONSTIRNG taskDeadLine;
JSONSTIRNG taskName;
JSONSTIRNG createDate;
JSONSTIRNG taskDescription;
JSONSTIRNG iconLocation;/**< 图片地址 */
JSONINT points;
@end
