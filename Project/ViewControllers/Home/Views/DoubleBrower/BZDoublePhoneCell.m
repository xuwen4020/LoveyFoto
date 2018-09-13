//
//  BZDoublePhoneCell.m
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZDoublePhoneCell.h"
#import "XWDoubleBrowerView.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "XWDownLoadData.h"

@interface BZDoublePhoneCell()<QSPDownloadToolDelegate,QSPDownloadSourceDelegate>

@property (nonatomic,strong) UIImageView *leftFrameImageView;
@property (nonatomic,strong) UIImageView *rightFrameImageView;
@property (nonatomic,strong) UIImageView *dateLeftImageView;
@property (nonatomic,strong) UIImageView *dateRightImageView;

@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingImageView;

@property (nonatomic,strong) KSYMoviePlayerController *leftplayer;
@property (nonatomic,strong) KSYMoviePlayerController *rightplayer;

//下载相关
@property (nonatomic,strong) QSPDownloadSource *leftdownloadSource;
@property (nonatomic,strong) QSPDownloadSource *rightdownloadSource;

@property (nonatomic,assign) BOOL leftIsReady;  //左边准备好了
@property (nonatomic,assign) BOOL rightIsReady; //右边准备好了

@property (nonatomic,strong) NSURL *leftURL;  //左边的地址
@property (nonatomic,strong) NSURL *rightURL; //右边的地址

@property (nonatomic,strong) UILabel *testLeftLabel;
@property (nonatomic,strong) UILabel *testRightLabel;

@end

@implementation BZDoublePhoneCell
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

- (void)baseUIConfig
{
    [self.contentView addSubview:self.leftImageview];
    [self.contentView addSubview:self.rightImageView];
    
    [self.contentView addSubview:self.leftFrameImageView];
    [self.contentView addSubview:self.rightFrameImageView];
    [self.leftFrameImageView addSubview:self.dateLeftImageView];
    [self.rightFrameImageView addSubview:self.dateRightImageView];
    

    [self.rightFrameImageView addSubview:self.loadingView];
    [self.loadingView addSubview:self.loadingImageView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerY.equalTo(self.leftFrameImageView);
        make.centerX.equalTo(self.leftFrameImageView.mas_right).offset(kCenter_EMPTY);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.center.equalTo(self.loadingView);
    }];
    
    [self.dateLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftFrameImageView).offset(25);
        make.left.equalTo(self.leftFrameImageView).offset(24);
        make.bottom.equalTo(self.leftFrameImageView).offset(-10);
        make.right.equalTo(self.leftFrameImageView).offset(-24);
    }];
    [self.dateRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightFrameImageView).offset(25);
        make.left.equalTo(self.rightFrameImageView).offset(24);
        make.bottom.equalTo(self.rightFrameImageView).offset(-10);
        make.right.equalTo(self.rightFrameImageView).offset(-24);
    }];
    
    
    //测试
    [self.leftFrameImageView addSubview:self.testLeftLabel];
    [self.rightFrameImageView addSubview:self.testRightLabel];
//    [self.testLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.leftFrameImageView);
//        make.width.height.equalTo(@100);
//    }];
//    [self.testRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.rightFrameImageView);
//        make.width.height.equalTo(@100);
//    }];
}

- (void)baseConstraintsConfig
{
    
}

#pragma mark - public
- (void)stopPlay
{
    [self.leftplayer stop];
    [self.rightplayer stop];
}


- (void)loadStart;
{
    self.loadingView.hidden = NO;
    self.loadingImageView.hidden = NO;
    [self.contentView bringSubviewToFront:self.loadingView];
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
    [self removeleftPlayer];
    [self removeRightPlayer];
}

- (void)removeleftPlayer
{
    [self.leftplayer reset:NO];
    [self.leftplayer stop];
    [self.leftplayer.view removeFromSuperview];
    self.leftplayer = nil;
}

- (void)removeRightPlayer
{
    [self.rightplayer reset:NO];
    [self.rightplayer stop];
    [self.rightplayer.view removeFromSuperview];
    self.rightplayer = nil;
}

- (void)loadVidioWithName:(NSString *)leftVideoName name:(NSString *)rightVidioName
{
    self.leftIsReady = NO;
    self.rightIsReady = NO;
    self.testRightLabel.text = nil;
    self.testLeftLabel.text = nil;
    
    [self loadVideo:leftVideoName withPlaer:self.leftplayer frameImaegView:self.leftFrameImageView isLeft:YES];
    [self loadVideo:rightVidioName withPlaer:self.rightplayer frameImaegView:self.rightFrameImageView isLeft:NO];
}

- (void)loadVideo:(NSString *)videoName withPlaer:(KSYMoviePlayerController *)player  frameImaegView:(UIImageView *)frameImageView  isLeft:(BOOL)isLeft
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
            if(isLeft){
                self.leftURL = [NSURL URLWithString:path];
                self.leftIsReady = YES;
            }else{
                self.rightURL = [NSURL URLWithString:path];
                self.rightIsReady = YES;
            }
            [self downloadCompleteToPlay];
        }else{
            //未完成
            BOOL fine = NO;
            for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
                if([source.fileName isEqualToString:fileName]){
                    //找到了
                    fine = YES;
                    [self loadStart];
                    if(isLeft){
                        self.leftdownloadSource = source;
                        self.leftdownloadSource.delegate = self;
                        if(self.leftdownloadSource.style == QSPDownloadSourceStyleDown||self.leftdownloadSource.style == QSPDownloadSourceStyleSuspend){
                            //继续下载
                            [[QSPDownloadTool shareInstance] continueDownload:self.leftdownloadSource];
                        }
                    }else{
                        self.rightdownloadSource = source;
                        self.rightdownloadSource.delegate = self;
                        if(self.rightdownloadSource.style == QSPDownloadSourceStyleDown||self.rightdownloadSource.style == QSPDownloadSourceStyleSuspend){
                            //继续下载
                            [[QSPDownloadTool shareInstance] continueDownload:self.rightdownloadSource];
                        }
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
                    if(isLeft){
                        [self downLoadLeftVideoWithName:videoName];
                    }else{
                        [self downLoadRightVideoWithName:videoName];
                    }
                }else{
                    [self showHint:@"file error"];
                }
                return;
            }
        }
    }else{
        [self loadStart];
        if(isLeft){
            [self downLoadLeftVideoWithName:videoName];
        }else{
            [self downLoadRightVideoWithName:videoName];
        }
    }
}

- (void)downLoadLeftVideoWithName:(NSString *)videoName
{
    [self loadStart];
    kXWWeakSelf(weakSelf);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //等待下载完毕后再去加载视频
        weakSelf.leftdownloadSource = [[QSPDownloadTool shareInstance] addDownloadTast:videoName andOffLine:YES];
        weakSelf.leftdownloadSource.delegate = weakSelf;
    });
}

- (void)downLoadRightVideoWithName:(NSString *)videoName
{
    [self loadStart];
    kXWWeakSelf(weakSelf);
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //等待下载完毕后再去加载视频
        weakSelf.rightdownloadSource = [[QSPDownloadTool shareInstance] addDownloadTast:videoName andOffLine:YES];
        weakSelf.rightdownloadSource.delegate = weakSelf;
    });
}

#pragma mark - QSPDownloadToolDelegate
- (void)downloadToolDidFinish:(QSPDownloadTool *)tool downloadSource:(QSPDownloadSource *)source
{
    NSLog(@"下载完毕");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:source.fileName];
}


#pragma mark - QSPDownloadSourceDelegate
- (void)downloadSource:(QSPDownloadSource *)source changedStyle:(QSPDownloadSourceStyle)style
{
    if(style == QSPDownloadSourceStyleFinished){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:source.fileName];
    }
    
    if(source == self.leftdownloadSource){
        if(style == QSPDownloadSourceStyleFinished && self.canPlay && [self.leftfileName isEqualToString:self.leftdownloadSource.fileName])
        {
            NSLog(@"下载完毕%@,存储的地址%@",source.fileName,source.location);
            [self removeleftPlayer];
            NSString *path = source.location;
            self.leftURL = [NSURL URLWithString:path];
            self.leftIsReady = YES;
            [self downloadCompleteToPlay];
        }
    }else{
        if(style == QSPDownloadSourceStyleFinished && self.canPlay && [self.rightfileName isEqualToString:self.rightdownloadSource.fileName])
        {
            NSLog(@"下载完毕%@,存储的地址%@",source.fileName,source.location);
            [self removeRightPlayer];
            NSString *path = source.location;
            self.rightURL = [NSURL URLWithString:path];
            self.rightIsReady = YES;
            [self downloadCompleteToPlay];
        }
    }
}

- (void)downloadCompleteToPlay
{
    if(self.leftIsReady && self.rightIsReady){
        [self loadStop];
        
        [self.leftplayer setUrl:self.leftURL];
        [self.leftplayer setShouldAutoplay:YES];
        [self.leftplayer setBufferSizeMax:2];  //缓冲
        [self.leftplayer setShouldLoop:NO];
        [self.leftplayer prepareToPlay];
        self.leftplayer.view.frame = kDOUBLE_LEFT_Frame;
        [self.contentView addSubview:self.leftplayer.view];
        [self.contentView bringSubviewToFront:self.leftFrameImageView];
        
        [self.rightplayer setUrl:self.rightURL];
        [self.rightplayer setShouldAutoplay:YES];
        [self.rightplayer setBufferSizeMax:2];  //缓冲
        [self.rightplayer setShouldLoop:NO];
        [self.rightplayer prepareToPlay];
        self.rightplayer.view.frame = kDOUBLE_RIGHT_Frame;
        [self.contentView addSubview:self.rightplayer.view];
        [self.contentView bringSubviewToFront:self.rightFrameImageView];
    }
}


- (void)downloadSource:(QSPDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten/(float)totalBytesExpectedToWrite;
    NSLog(@"%@⬇️⬇️⬇️⬇️⬇️%.1f%%",source.fileName,progress*100);
    if(source == self.leftdownloadSource){
        self.testLeftLabel.text = [NSString stringWithFormat:@"test:%.1f%%",progress*100];
    }else{
        self.testRightLabel.text = [NSString stringWithFormat:@"test:%.1f%%",progress*100];
    }
}


#pragma mark - getter & setter
- (UIImageView *)leftImageview
{
    if(!_leftImageview){
        _leftImageview = [[UIImageView alloc]initWithFrame:kDOUBLE_LEFT_Frame];
//        _leftImageview.backgroundColor = [UIColor blueColor];
        [_leftImageview xwDrawCornerWithRadiuce:8];
    }
    return _leftImageview;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc]initWithFrame:kDOUBLE_RIGHT_Frame];
//        _rightImageView.backgroundColor = [UIColor blueColor];
        [_rightImageView xwDrawCornerWithRadiuce:8];
    }
    return _rightImageView;
}

- (UIImageView *)dateLeftImageView
{
    if(!_dateLeftImageView){
        _dateLeftImageView = [[UIImageView alloc]init];
        _dateLeftImageView.image = XWImageName(@"EditThis");
    }
    return _dateLeftImageView;
}

- (UIImageView *)dateRightImageView
{
    if(!_dateRightImageView){
        _dateRightImageView = [[UIImageView alloc]init];
        _dateRightImageView.image = XWImageName(@"EditThis");
    }
    return _dateRightImageView;
}

- (UIImageView *)leftFrameImageView
{
    if(!_leftFrameImageView){
        _leftFrameImageView = [[UIImageView alloc]initWithImage:XWImageName(@"frame")];
        _leftFrameImageView.frame = kDOUBLE_LEFT_PhoneFrame;
        _leftFrameImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftFrameImageView;
}

- (UIImageView *)rightFrameImageView
{
    if(!_rightFrameImageView){
        _rightFrameImageView = [[UIImageView alloc]initWithImage:XWImageName(@"frame")];
        _rightFrameImageView.frame = kDOUBLE_RIGHT_PhoneFrame;
        _rightFrameImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightFrameImageView;
}

- (KSYMoviePlayerController *)leftplayer
{
    if(!_leftplayer){
        _leftplayer = [[KSYMoviePlayerController alloc] init];
        _leftplayer.view.backgroundColor = [UIColor clearColor];
        _leftplayer.view.autoresizesSubviews = true;
        [_leftplayer.view xwDrawCornerWithRadiuce:10];
        _leftplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _leftplayer.scalingMode = MPMovieScalingModeAspectFill;
    }
    return _leftplayer;
}

- (KSYMoviePlayerController *)rightplayer
{
    if(!_rightplayer){
        _rightplayer = [[KSYMoviePlayerController alloc] init];
        _rightplayer.view.backgroundColor = [UIColor clearColor];
        _rightplayer.view.autoresizesSubviews = true;
        [_rightplayer.view xwDrawCornerWithRadiuce:10];
        _rightplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _rightplayer.scalingMode = MPMovieScalingModeAspectFill;
    }
    return _rightplayer;
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

- (void)setShowTime:(BOOL)showTime
{
    _showTime = showTime;
    self.dateLeftImageView.hidden = !showTime;
    self.dateRightImageView.hidden = !showTime;
}

- (UILabel *)testLeftLabel
{
    if(!_testLeftLabel){
        _testLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _testLeftLabel.backgroundColor = [UIColor clearColor];
        [_testLeftLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(13) aliment:NSTextAlignmentCenter];
        _testLeftLabel.hidden = YES;
    }
    return _testLeftLabel;
}

- (UILabel *)testRightLabel
{
    if(!_testRightLabel){
        _testRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _testRightLabel.backgroundColor = [UIColor clearColor];
        [_testRightLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(13) aliment:NSTextAlignmentCenter];
        _testRightLabel.hidden = YES;
    }
    return _testRightLabel;
}

@end
