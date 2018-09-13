//
//  BZPhoneBrowerCell.m
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZPhoneBrowerCell.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "XWDownLoadData.h"

//#define kShowWidth (kFRAME_HEIGHT-kEDGE*2)*kWidthRatHeight

//#define kShowFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0, 15, kShowWidth, kFRAME_HEIGHT)
//#define kPhoneFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0-15, 0, kShowWidth+30, kFRAME_HEIGHT+30)

@interface BZPhoneBrowerCell()<QSPDownloadToolDelegate,QSPDownloadSourceDelegate>
@property (nonatomic,strong) KSYMoviePlayerController *player;
//@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,strong) UIImageView *frameImageView;
@property (nonatomic,strong) UIImageView *dateImageView;

@property (nonatomic,strong) UIImageView *alarmImageView;

@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingImageView;
//下载相关
@property (nonatomic,strong) QSPDownloadSource *downloadSource;

@end

@implementation BZPhoneBrowerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [[QSPDownloadTool shareInstance] addDownloadToolDelegate:self];
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

//- (void)handlePlayerPreparedToPlayNotify
//{
//    self.player.loadState
//}

#pragma mark - public

- (void)loadStart;
{
    self.loadingView.hidden = NO;
    self.loadingImageView.hidden = NO;
    [self.loadingImageView startAnimating];
}
- (void)loadStop
{
    [self.loadingImageView stopAnimating];
    self.loadingImageView.hidden = YES;
    self.loadingView.hidden = YES;
}

- (void)removePlayer
{
    [self.player reset:NO];
    [self.player stop];
    [self.player.view removeFromSuperview];
    self.player = nil;
}

- (void)prepareVideoWithName:(NSString *)videoName
{
    NSLog(@"%@",[NSString stringWithFormat:@"prepare👩%@",videoName]);
    /**
     * 预加载逻辑
     *
     */
    NSString *path = [[QSPDownloadTool shareInstance]pathWithURL:videoName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[QSPDownloadTool shareInstance] nameWithURLStr:videoName];
    if([fileManager fileExistsAtPath:path]){
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:fileName]){
            //文件已经下载完毕
            return;
        }else{
            //文件没有下载完毕
            BOOL fine = NO;
            for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
                if([source.fileName isEqualToString:fileName]){
                    //找到了
                    fine = YES;
//                    [self loadStart];
                    self.downloadSource = source;
                    source.delegate = self;
                    if(self.downloadSource.style == QSPDownloadSourceStyleDown||self.downloadSource.style == QSPDownloadSourceStyleSuspend){
                        //继续下载
                        [[QSPDownloadTool shareInstance] continueDownload:self.downloadSource];
                    }
                    return;
                }
            }
            //未找到
            if(fine == NO){
//                [self loadStart];
                //在文件中有,但是要重新去下载,这里要先将文件中的删除,不然地址为 XXXX(n)
                NSError *error = nil;
                if([fileManager removeItemAtPath:path error:&error]){
                    [self downLoadVideoWithName:videoName];
                }else{
                    [self showHint:@"file error"];
                }
                return;
            }
        }
        
    }else{
        [self loadStart];
        [self downLoadVideoWithName:videoName];
    }
}

- (void)loadVidioWithName:(NSString *)videoName
{
    /**
     * 下载逻辑
     * 1.通过 url 得到应该存储的文件地址 path,通过 path 找文件,如果找到了进入2,如果没有找到进入3.
     * 2.通过地址 path 去找文件,如果找到了有两种情况 2.1文件完整(做了UserDefault标识),可以直接播放,  2.2文件不完整
     * 2.1文件完整,可以直接播放,播放文件
     * 2.2文件不完整 去下载列表查看,分为两种情况 2.2.1 下载列表中有, 2.2.2 下载列表中没有
     * 2.2.1 下载列表中有,继续下载.
     * 2.2.2 下载列表中没有,删除掉原来的残余文件,然后重新下载
     * 3.直接下载
     */
    
    NSLog(@"%@",[NSString stringWithFormat:@"👱%@",videoName]);

    NSString *path = [[QSPDownloadTool shareInstance]pathWithURL:videoName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[QSPDownloadTool shareInstance] nameWithURLStr:videoName];
    if([fileManager fileExistsAtPath:path]){
        /*
            完成了,直接加载
            未完成 去找下载任务,找到就显示,找不到就下载
         */
        if([[NSUserDefaults standardUserDefaults]boolForKey:fileName]){
            //完成了
            [self loadStop];
            NSURL *url = [NSURL URLWithString:path];
            [self.player setUrl:url];
            [self.player setShouldAutoplay:YES];
            [self.player setBufferSizeMax:2];  //缓冲
            [self.player setShouldLoop:YES];
            [self.player prepareToPlay];
            
            self.player.view.frame = kShowFrame;
            [self.contentView addSubview:self.player.view];
            [self.contentView bringSubviewToFront:self.frameImageView];
        }else{
            //未完成
            BOOL fine = NO;
            for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
                if([source.fileName isEqualToString:fileName]){
                    //找到了
                    fine = YES;
                    [self loadStart];
                    self.downloadSource = source;
                    source.delegate = self;
                    if(self.downloadSource.style == QSPDownloadSourceStyleDown||self.downloadSource.style == QSPDownloadSourceStyleSuspend){
                        //继续下载
                        [[QSPDownloadTool shareInstance] continueDownload:self.downloadSource];
                    }
                    return;
                }
            }
            //未找到
            if(fine == NO){
                [self loadStart];
                //在文件中有,但是要重新去下载,这里要先将文件中的删除,不然地址为 XXXX(n)
                NSError *error = nil;
                if([fileManager removeItemAtPath:path error:&error]){
                    [self downLoadVideoWithName:videoName];
                }else{
                    [self showHint:@"file error"];
                }
                return;
            }
        }
    }else{
        [self loadStart];
        [self downLoadVideoWithName:videoName];
    }
}


- (void)downLoadVideoWithName:(NSString *)videoName
{
    kXWWeakSelf(weakSelf);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //等待下载完毕后再去加载视频
        weakSelf.downloadSource = [[QSPDownloadTool shareInstance] addDownloadTast:videoName andOffLine:YES];
        weakSelf.downloadSource.delegate = weakSelf;
    });
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.frameImageView.frame = kPhoneFrame;
    self.bgImageView.frame = kShowFrame;
    [self.contentView addSubview:self.alarmImageView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.frameImageView];
    [self.frameImageView addSubview:self.dateImageView];
    [self.frameImageView addSubview:self.loadingView];
    [self.loadingView addSubview:self.loadingImageView];
    
    [self.alarmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@45);
        make.center.equalTo(self.bgImageView);
    }];
    
    [self.dateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frameImageView).offset(25);
        make.left.equalTo(self.frameImageView).offset(24);
        make.bottom.equalTo(self.frameImageView).offset(-10);
        make.right.equalTo(self.frameImageView).offset(-24);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.center.equalTo(self.bgImageView);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.center.equalTo(self.loadingView);
    }];
}

- (void)baseConstraintsConfig
{
    
}

#pragma mark - QSPDownloadToolDelegate
- (void)downloadToolDidFinish:(QSPDownloadTool *)tool downloadSource:(QSPDownloadSource *)source
{
    NSLog(@"下载完毕");
    //标记下载完成
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:source.fileName];
//    [self loadStop];
}


#pragma mark - QSPDownloadSourceDelegate
- (void)downloadSource:(QSPDownloadSource *)source changedStyle:(QSPDownloadSourceStyle)style
{
    if(style == QSPDownloadSourceStyleFinished){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:source.fileName];
    }
    
//    NSLog(@"%@-----%@",self.fileName,source.fileName);
    
    if(style == QSPDownloadSourceStyleFinished && self.canPlay && [self.fileName isEqualToString:source.fileName])
    {
        [self loadStop];
        [self removePlayer];
        
        NSLog(@"下载完毕%@,存储的地址%@",source.fileName,source.location);
        NSString *path = source.location;
        
        NSURL *url = [NSURL URLWithString:path];
        [self.player setUrl:url];
        [self.player setShouldAutoplay:YES];
        [self.player setBufferSizeMax:2];  //缓冲
        [self.player setShouldLoop:YES];
        [self.player prepareToPlay];
        
        self.player.view.frame = kShowFrame;
        [self.contentView addSubview:self.player.view];
        [self.contentView bringSubviewToFront:self.frameImageView];
    }
}

- (void)downloadSource:(QSPDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.loadingImageView.hidden = NO;
    float progress = totalBytesWritten/(float)totalBytesExpectedToWrite;
    NSLog(@"%@⬇️⬇️⬇️⬇️⬇️%.1f%%",source.fileName,progress*100);
}


#pragma mark - setter & getter
- (UIImageView *)frameImageView
{
    if(!_frameImageView){
        _frameImageView = [[UIImageView alloc]initWithImage:XWImageName(@"frame")];
    }
    return _frameImageView;
}

- (UIImageView *)dateImageView
{
    if(!_dateImageView){
        _dateImageView = [[UIImageView alloc]init];
        _dateImageView.image = XWImageName(@"EditThis");
    }
    return _dateImageView;
}
//
//- (UILabel *)progressLabel
//{
//    if(!_progressLabel){
//        _progressLabel = [[UILabel alloc]init];
//        [_progressLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(18) aliment:NSTextAlignmentCenter];
//        _progressLabel.text = @"0.0%";
//    }
//    return _progressLabel;
//}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        [_bgImageView xwDrawCornerWithRadiuce:10];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (KSYMoviePlayerController *)player
{
    if(!_player){
        _player = [[KSYMoviePlayerController alloc] init];
        _player.view.backgroundColor = [UIColor clearColor];
        _player.view.autoresizesSubviews = true;
        [_player.view xwDrawCornerWithRadiuce:10];
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.scalingMode = MPMovieScalingModeAspectFill;
    }
    return _player;
}

- (UIView *)loadingView
{
    if(!_loadingView){
        _loadingView = [[UIView alloc]init];
        _loadingView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_loadingView xwDrawCornerWithRadiuce:15];
    }
    return _loadingView;
}

- (UIImageView *)loadingImageView
{
    if(!_loadingImageView){
        _loadingImageView = [[UIImageView alloc]init];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0;i<136;i++){
            NSString *str =  [NSString stringWithFormat:@"19_white_00%03d",i];
            [array addObject:XWImageName(str)];
        }
        _loadingImageView.animationDuration = 2.0;
        _loadingImageView.animationImages = array;
        _loadingImageView.animationRepeatCount = 0;
        [_loadingImageView startAnimating];
    }
    return _loadingImageView;
}

- (void)setCanPlay:(BOOL)canPlay
{
    _canPlay = canPlay;
}

- (void)setShowTime:(BOOL)showTime
{
    _showTime = showTime;
    self.dateImageView.hidden = !showTime;
}

- (void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
}

- (UIImageView *)alarmImageView
{
    if(!_alarmImageView){
        _alarmImageView = [[UIImageView alloc]init];
//        NSMutableArray *array = [NSMutableArray array];
//        for(int i = 0;i<149;i++){
//            NSString *str =  [NSString stringWithFormat:@"2_dark_00%03d",i];
//            [array addObject:XWImageName(str)];
//        }
//        _alarmImageView.animationDuration = 3.0;
//        _alarmImageView.animationImages = array;
//        _alarmImageView.animationRepeatCount = 0;
//        [_alarmImageView startAnimating];
    }
    return _alarmImageView;
}

@end
