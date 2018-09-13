//
//  BZWelcomeView.m
//  Project
//
//  Created by xuwen on 2018/8/28.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZWelcomeView.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#define kBannerHeight kSCREEN_WIDTH/375*254
@interface BZWelcomeView()
@property (nonatomic,strong) KSYMoviePlayerController *player;
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation BZWelcomeView

+ (void)appear
{
    BZWelcomeView *welcome = [[BZWelcomeView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:welcome];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
            welcome.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kBannerHeight);
        } completion:^(BOOL finished) {
            [welcome removeFromSuperview];
            [welcome.player pause];
            [welcome.player.view removeFromSuperview];
            welcome.player = nil;
        }];
    });
}

+ (void)disappear
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
    }
    return self;
}

- (void)baseUIConfig
{
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"壁纸10" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:path];
    [self.player setUrl:url];
    [self.player setShouldAutoplay:YES];
    [self.player setBufferSizeMax:2];  //缓冲
    [self.player setShouldLoop:YES];
    [self.player prepareToPlay];
    self.player.view.frame = self.frame;
    [self addSubview:self.player.view];
}

- (void)baseConstraintsConfig
{
    
}

- (KSYMoviePlayerController *)player
{
    if(!_player){
        _player = [[KSYMoviePlayerController alloc] init];
        _player.view.backgroundColor = [UIColor clearColor];
        _player.view.autoresizesSubviews = true;
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.scalingMode = MPMovieScalingModeAspectFill;
    }
    return _player;
}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = XWImageName(@"壁纸10.png");
    }
    return _bgImageView;
}
@end
