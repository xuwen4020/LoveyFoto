//
//  IPTest.m
//  Secondnumber
//
//  Created by chenliyang on 28/03/2018.
//  Copyright © 2018 SecondNumber. All rights reserved.
//

#import "IPTest.h"

static NSString* defaultConfig = @"{\"city\":[\"Menlo Park\",\"Cupertino\",\"San Jose\",\"Reno\"],\"link\":[{\"url\":\"http://geoip.nekudo.com/api/\",\"type\":\"json\",\"key\":\"city\",\"encode\":\"utf8\"},{\"url\":\"https://ipinfo.io/json/\",\"type\":\"json\",\"key\":\"city\",\"encode\":\"utf8\"}]}";
static NSString* serverAddress = @"https://s3-us-west-1.amazonaws.com/appconfigfiles/reviewconfig.txt";
//测试address:屏蔽香港IP
//https://s3-us-west-2.amazonaws.com/datingmenow/ip_limit_test/iptestdebug.json

//审核状态的配置文件所在文件夹，usingReviewFlag=YES时，生效
static NSString* reviewFlagPath = @"https://s3-us-west-1.amazonaws.com/reviewflag/";

static NSString* recordServerUrl = @"http://saveemail.testwj.club/ip_record.php";

static NSString* IPTestUDKey = @"IPTestUDKey20180423";
#define TimeOutSeconds   5
//默认10秒超时

NSString *getUUID() {
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrAccount : @"user",
                            (__bridge id)kSecAttrService : @"uuid",
                            };
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    if (status == errSecSuccess) {
        NSString *uuid = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataTypeRef) encoding:NSUTF8StringEncoding];
        return uuid;
    } else if (status == errSecItemNotFound) {
        NSDictionary *query = @{(__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                                (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecValueData : [[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding],
                                (__bridge id)kSecAttrAccount : @"user",
                                (__bridge id)kSecAttrService : @"uuid",
                                };
        CFErrorRef error = NULL;
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, nil);
        
        return getUUID();
    } else {
        return nil;
    }
}

@implementation IPTest

- (id)init
{
    if([super init])
    {
        _citys = [NSMutableSet set];
        _currentThread = nil;
        _completion = nil;
        _result = NO;
        _timeOut = NO;
    }
    return self;
}

+ (void) checkIp:(void (^)(BOOL isApple))completion usingReivewFlag:(BOOL)usingflag;//静态入口
{
    [[[IPTest alloc] init] checkIpHelper:completion usingReviewFlag:usingflag];
}

- (void)checkIpHelper:(void (^)(BOOL))completion usingReviewFlag:(BOOL)reivewFlag//入口
{
    _completion = completion;
    _usingReviewFlag = reivewFlag;
    _bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    _app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _launch = [[NSUUID UUID] UUIDString];
    /*{
        CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
        CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
        NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
        CFRelease(uuid_ref);
        CFRelease(uuid_string_ref);
        _launch = [uuid lowercaseString];
    }*/
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:IPTestUDKey] != nil)
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:IPTestUDKey] > 0)
        {
            completion(YES);
        }
        else
        {
            completion(NO);
        }
        _completion = nil;
    }
    
    _currentThread = [NSThread currentThread];
    [self createTimeOutTask];
    [NSThread detachNewThreadSelector:@selector(begin) toTarget:self withObject:nil];
}

- (void)pushResultOnCallThread//从原先的线程回调结果，出口
{
    if(_timeOut == NO)
    {
        if(_result)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:IPTestUDKey];
        }
        else
        {
            NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:IPTestUDKey];
            count --;
            [[NSUserDefaults standardUserDefaults] setInteger:MAX(count,0) forKey:IPTestUDKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(_completion)
    {
        //NSLog(@"check_I_p is_A_p_p_l_e:%@",_result?@"YES":@"NO");
        _completion(_result);
        _completion = nil;
    }
}

- (void)pushResult:(BOOL)result//回调结果
{
    self.result = result;
    [self performSelector:@selector(pushResultOnCallThread) onThread:_currentThread withObject:nil waitUntilDone:NO];
}

- (void)begin//获取服务器config,获取失败 或者 使用服务器配置创建任务失败，那么使用默认配置创建任务
{
    if(_usingReviewFlag)
    {
        NSString *defaultsKey = [_bundleId stringByAppendingString:_app_version];
        if([[NSUserDefaults standardUserDefaults] objectForKey:defaultsKey] == nil)//一旦取到过0，那么该版本就不再去取了
        {
            NSString *flagUrl = [reviewFlagPath stringByAppendingString:_bundleId];
            NSError *error = nil;
            NSString *flag = [NSString stringWithContentsOfURL:[NSURL URLWithString:flagUrl] encoding:NSUTF8StringEncoding error:&error];
            if(error)
            {
                error = nil;
                flag = [NSString stringWithContentsOfURL:[NSURL URLWithString:flagUrl] encoding:NSUTF8StringEncoding error:&error];
            }
            if(error == nil && ([flag isEqualToString:@"1"] || [flag isEqualToString:_app_version]))
            {
                [self pushResult:true];
            }
            if([flag isEqualToString:@"0"])
            {
                //一旦取到过0，那么该版本就不再去取了
                [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:defaultsKey];
            }
        }
        
    }
    
    NSURL *configUrl = [NSURL URLWithString:serverAddress];
    NSError *error = nil;
    //默认使用NSUnicodeStringEncoding从服务器获取配置文件
    NSString *configString = [NSString stringWithContentsOfURL:configUrl
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
    if(error)
    {
        NSLog(@"%@",error);
        if(error.domain == NSCocoaErrorDomain && error.code == 261)//编码格式错误，使用UTF8再尝试一次
        {
            error = nil;
            configString = [NSString stringWithContentsOfURL:configUrl encoding:NSUnicodeStringEncoding error:&error];
            if(error)
                NSLog(@"%@",error);
        }
    }
    if(error || [self createTask:configString] == false)//获取配置错误，或者，创建任务失败，使用默认配置创建任务
    {
        [self createTask:defaultConfig];
    }
}

- (NSString *)trimString:(NSString *)string//首先转化成小写字母，然后去除 除字母外 的其他字符
{
    string = [string lowercaseString];
    NSMutableString *outputString = [NSMutableString stringWithString:@""];
    for(int i = 0;i <[string length]; ++i)
    {
        unichar c = [string characterAtIndex:i];
        if(c >= 'a' && c <= 'z')
        {
            [outputString appendFormat:@"%c",c];
        }
    }
    return outputString;
}

- (BOOL)createTask:(NSString *)configString//先检查格式，假如正确，就创建任务
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[configString              dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if(error)//配置文件创建Json失败
    {
        NSLog(@"%@",error);
        return false;
    }
    if(jsonObject == nil || [jsonObject isKindOfClass: [NSDictionary class]] == false)//检查是否是object格式
    {
        NSLog(@"root type is not NSDictionary");
        return false;
    }
    NSArray *cityArray = [jsonObject objectForKey:@"city"];
    //city为空或者格式错误
    if(cityArray == nil || [cityArray isKindOfClass:[NSArray class]] == false || [cityArray count] == 0 )
    {
        NSLog(@"city array is nil or city is not array");
        return false;
    }
    [_citys removeAllObjects];//清空，上一次调用createTask可能留下内容
    for(int i = 0;i < [cityArray count]; ++ i)
    {
        id key = [cityArray objectAtIndex:i];
        if([key isKindOfClass: [NSString class]])//是否为字符串
        {
            [_citys addObject: [self trimString:key]];//先处理一下key再存
        }
    }
    if([_citys count] == 0)//city为空
    {
        return false;
    }
    NSArray *linkArray = [jsonObject objectForKey:@"link"];
    //第三方库link 为空或者格式错误
    if(linkArray == nil || [linkArray isKindOfClass:[NSArray class]] == false || [linkArray count] == 0)
    {
        NSLog(@"link array is nil or link is not array");
        return false;
    }
    bool correct = true;
    for(int i = 0;i < [linkArray count]; ++ i)
    {
        id obj = [linkArray objectAtIndex:i];
        if([obj isKindOfClass: [NSDictionary class]] == false)//检查是否是Object格式
        {
            correct = false;
            break;
        }
        id url = [obj objectForKey:@"url"];
        id type = [obj objectForKey:@"type"];
        id key = [obj objectForKey:@"key"];
        id encode = [obj objectForKey:@"encode"];
        //检查四个参数，是否都有
        if(url == nil || type == nil || key == nil || encode == nil)
        {
            correct = false;
            break;
        }
        //检查四个参数，是否都是字符串
        if([url isKindOfClass:[NSString class]] == false || [type isKindOfClass:[NSString class]] == false || [key isKindOfClass:[NSString class]] == false || [encode isKindOfClass:[NSString class]] == false)
        {
            correct = false;
            break;
        }
        //返回数据的type,必须是json或者xml
        if([type isEqualToString:@"json"] == false && [type isEqualToString:@"xml"] == false)
        {
            correct = false;
            break;
        }
    }
    //格式不正确
    if(correct == false)
        return false;
    _taskCount = [linkArray count];
    //创建任务
    for(NSDictionary *dictionary in linkArray)
    {
        [NSThread detachNewThreadSelector:@selector(doTask:) toTarget:self withObject:dictionary];
    }
    return true;
}

- (void)doTask:(NSDictionary *)dictionary
{
    NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
    NSString *type = [dictionary objectForKey:@"type"];
    NSString *key = [dictionary objectForKey:@"key"];
    NSString *encode = [dictionary objectForKey:@"encode"];
    NSError *error = nil;
    NSStringEncoding encoding = NSUTF8StringEncoding;
    if([encode isEqualToString:@"unicode"])//编码格式
    {
        encoding = NSUnicodeStringEncoding;
    }
    NSString *responseString = [NSString stringWithContentsOfURL:url
                                                        encoding:encoding
                                                           error:&error];
    if(error)
    {
        NSLog(@"%@",error);
        [self taskFail];
        return;
    }
    NSString *cityValue = nil;
    //type = @"xml";//测试代码
    //responseString = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><data>d</data><city>hongkong</city>";
    NSString *cityFullName = nil;
    if([type isEqualToString:@"json"])
    {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:[responseString              dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        if(error)
        {
            NSLog(@"%@",error);
            [self taskFail];
            return;
        }
        id value = [jsonObject objectForKey:key];
        //没有city或者格式错误
        if(value == nil || [value isKindOfClass:[NSString class]] == false)
        {
            [self taskFail];
            return;
        }
        NSLog(@"city:%@",value);
        cityFullName = value;
        cityValue = [self trimString:value];
    }
    else if([type isEqualToString:@"xml"])
    {
        //不用把所有的节点都解析出来，只解析了与city有关的
        NSString *beginKey = [NSString stringWithFormat:@"<%@>",key];
        NSString *endKey = [NSString stringWithFormat:@"</%@>",key];
        NSRange beginRange = [responseString rangeOfString:beginKey];
        NSRange endRange = [responseString rangeOfString:endKey];
        NSRange valueRange;
        if(beginRange.length == 0 || endRange.length == 0)
        {
            [self taskFail];
            return;
        }
        valueRange.location = beginRange.location + beginRange.length;
        valueRange.length = endRange.location - valueRange.location;
        NSString *value = [responseString substringWithRange:valueRange];
        NSLog(@"city:%@",value);
        cityFullName = value;
        cityValue = [self trimString:value];
    }
    else//type 格式错误
    {
        [self taskFail];
    }
    if([_citys containsObject: cityValue])
    {
        [self pushResult:true];
    }
    else
    {
        [self pushResult:false];
    }
    NSDictionary *params = @{@"city":cityFullName,
                             @"device":getUUID(),
                             @"launch":_launch,
                             @"app_version":_app_version,
                             @"bundle_id":_bundleId,
                             @"source":[dictionary objectForKey:@"url"]};
    NSMutableArray *paramArray = [NSMutableArray array];
    for(NSString *key in [params allKeys])
    {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
    }
    NSString *paramString = [paramArray componentsJoinedByString:@"&"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:recordServerUrl]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
}

- (void)taskFail//任务失败调用，假如所有任务都失败，返回false
{
    @synchronized(self)
    {
        _taskCount --;
    }
    if(_taskCount == 0)
    {
        [self pushResult:false];
    }
}

- (void)createTimeOutTask//超时返回false
{
    double delayInSeconds = TimeOutSeconds;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"iptestfirstkey"] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"iptestfirstkey" forKey:@"iptestfirstkey"];
        delayInSeconds *= 4;
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"check_i_p:time out");
        _timeOut = YES;
        [self pushResult:false];
    });
    
}



@end

