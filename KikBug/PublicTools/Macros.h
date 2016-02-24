//
//  Macros.h
//  KikBug
//
//  Created by DamonLiu on 15/11/9.
//  Copyright © 2015年 DamonLiu. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/***Model Definitions**/
#define JSONSTIRNG @property (copy,nonatomic,readwrite) NSString*
#define JSONINT @property (assign,nonatomic) NSInteger
#define JSONARRAY @property (strong,nonatomic) NSArray*
/***App Font Size ****/
#define APP_FONT_SIZE_MIDDLE 12
#define APP_FONT_SIZE_LARGE  14
#define APP_FONT_SIZE_SMALL  10


/*****Fonts*****/
#define APP_FONT_NORMAL [NSF




/****Font Attribute**/
#define SUBTITLE_ATTRIBUTE @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor grayColor]}

#define TITLE_ATTRIBUTE @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}
//获取屏幕 宽度、高度
#define IsPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

#define SCREEN_WIDTH (IsPortrait ? MIN(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)) : MAX(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)))

#define SCREEN_HEIGHT (IsPortrait ? MAX(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)) : MIN(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)))


//weak self

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;



//load url from plist
#define GETURL(key) (NSString*)[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"url" ofType:@"plist"]] objectForKey:key]
#define APPKEY (NSString*)[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"property" ofType:@"plist"]] objectForKey:@"AppKey"]


//
#define TIP_LOADING                                 @"加载中..."           //加载中...


//单例模式的宏
#define SINGLETON_INTERFACE(className,singletonName) +(className *)singletonName;

#define SINGLETON_IMPLEMENTION(className,singletonName)\
\
static className *_##singletonName = nil;\
\
+ (className *)singletonName\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_##singletonName = [[super allocWithZone:NULL] init];\
});\
return _##singletonName;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
return [self singletonName];\
}\
\
+ (id)copyWithZone:(struct _NSZone *)zone\
{\
return [self singletonName];\
}\




/************************************* Color ****************************************************/

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define HEXCOLOR(hexColorValue) [UIColor colorWithHex:hexColorValue]
#define THEME_COLOR RGB(80,118,156)

/************************************* Margin ****************************************************/
#define SMALL_MARGIN  5
#define MEDIUM_MARGIN  10
#define LARGE_MARGIN  15

#define APP_FONT(size) [UIFont systemFontOfSize:size]
#define TOP_TOOL_BAR_HEIGHT  64
#define BOTTOM_BAR_HEIGHT  49
#endif /* Macros_h */

/************************************* Login ****************************************************/
#define USER_STATUS @"USER_STATUS"


/************************************* Navigation Page Name ****************************************************/
#define LOGIN_PAGE_NAME @"/user/login"
#define MY_TASK_PAGE_NAME @"/user/tasklist"
#define GROUPR_PAGE_NAME @"/user/group"
#define TASK_DETAIL @"/taskDetail"
