//
//  XWKitDefines.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//


//-------------------屏幕尺寸---------------------
//屏幕宽高
#define kSCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT          [[UIScreen mainScreen] bounds].size.height
#define kIS_iPhoneX             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define  kStatusBarHeight       (kIS_iPhoneX ? 44.f : 20.f)
#define  kNavigationBarHeight   44.f
#define  kTabbarHeight          (kIS_iPhoneX ? (49.f+34.f) : 49.f)
#define  kSafeAreaBottomHeight  (kIS_iPhoneX ? 34.f : 0.f)
#define  kStatusBarAndNavigationBarHeight  (kIS_iPhoneX ? 88.f : 64.f)
#define KBaseNavi_Height        56
#define kIS_IPAD  [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#define kIS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]\
? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)\
|| CGSizeEqualToSize(CGSizeMake(1136, 640), [[UIScreen mainScreen] currentMode].size) : NO)

//------------------- 颜色 ---------------------
#define RGB(r,g,b)              [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define ColorHex(_hex_)         [UIColor colorWithHexCode:((__bridge NSString *)CFSTR(#_hex_))]
#define ColorHex_Alpha(_hex_,a) [UIColor colorWithHexCode:((__bridge NSString *)CFSTR(#_hex_)) alpha:a]
#define Random_Color            RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1)

//色彩配置
#define ColorClear              [UIColor clearColor]
#define ColorRed                [UIColor redColor]
#define ColorOrange             [UIColor orangeColor]
#define ColorWhite              [UIColor whiteColor]
#define ColorBlack              [UIColor blackColor]
#define ColorGreen              [UIColor greenColor]
#define ColorGray               [UIColor grayColor]
#define ColorDarkGray           [UIColor darkGrayColor]
#define ColorLightGray          [UIColor lightGrayColor]
#define ColorPurple             [UIColor purpleColor]
#define ColorCyan               [UIColor cyanColor]
#define ColorBlue               [UIColor blueColor]


//------------------- 字体 ---------------------
#define Font(A)                 [UIFont systemFontOfSize:(A)]
#define FontBold(A)             [UIFont boldSystemFontOfSize:(A)]
#define FontName(name,size)     [UIFont fontWithName:(name) size:(size)]

//------------------- 图片 ---------------------
#define XWImageName(name)          [UIImage imageNamed:(name)]

//------------------- log ---------------------
#ifdef DEBUG
#define MyLog(...)  NSLog(@">>>:%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#   define MyLog(...)
#endif

//------------------- block---------------------
#define kXW_EXECUTE_BLOCK(A,...)            if(A != NULL) {A(__VA_ARGS__);}

//------------------- weak ---------------------
#define kXWWeakSelf(weakName)   __weak typeof(self) weakName = self
#define kXWWeak(name,weakName)  __weak typeof(name) weakName = name


// 本地化字符串
// NSLocalizedString(key, comment) 本质
// NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
#define XWLocalizedString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

/**
 *  单例宏
 *
 *  @param name : 类名
 */
#define SingletonH(name) + (instancetype)shared##name;
#if __has_feature(objc_arc)
#define SingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
}

#else

#define SingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
} \
\
- (oneway void)release {} \
- (id)retain {return self;} \
- (NSUInteger)retainCount {return 1;} \
- (id)autorelease {return self;}


#define LANGUAGE_RIGHT_TO_LEFT \
^(){\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
NSArray *languages = [defaults objectForKey:@"AppleLanguages"];\
NSString *currentLanguage = [languages objectAtIndex:0];\
if ([currentLanguage rangeOfString:@"ar"].length>0) {\
return YES;\
}else{\
return NO;\
}\
}()

#endif



