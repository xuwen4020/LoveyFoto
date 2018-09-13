//
//  BZSubjectVC.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSubjectVC.h"
#import "BZSubjectCell.h"
#import "BZSubDetailVC.h"
#import "MJRefresh.h"

@interface BZSubjectVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation BZSubjectVC
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    [self notificationConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event
- (void)loadNewData
{
    [self.mainTableView.mj_header beginRefreshing];
    kXWWeakSelf(weakSelf);
    [[BZDataTool sharedBZDataTool]dataConfigWithBlock:^(BOOL isSuccess) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_UPLOAD_DATA object:nil];
        });
    }];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    [self navBackButton];
}

- (void)baseConstraintsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataReload) name:APP_EVNET_UPLOAD_DATA object:nil];
}

- (void)loadDataReload
{
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BZDataTool sharedBZDataTool].subjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:kBZSubjectCellIdentifier forIndexPath:indexPath];
    NSArray <LCPPlayerDataModel *>*array = [BZDataTool sharedBZDataTool].subjectArray[indexPath.row];
    LCPPlayerDataModel *model = array.firstObject;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.staticImageStr] placeholderImage:XWImageName(@"placeholder")];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubject_HEIGHT + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(kUser.isVIP){
        NSArray <LCPPlayerDataModel *>*array = [BZDataTool sharedBZDataTool].subjectArray[indexPath.row];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
        if(mutableArray.count >= 1){
            [mutableArray removeObjectAtIndex:0];
        }
        
        BZSubDetailVC *vc = [[BZSubDetailVC alloc]init];
        vc.parentVC = self.parentVC;
        vc.dataArray = [NSMutableArray arrayWithArray:mutableArray];
        [self.parentVC.navigationController pushViewController:vc animated:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull BZSubjectCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSArray <LCPPlayerDataModel *>*array = [BZDataTool sharedBZDataTool].subjectArray[indexPath.row];
    LCPPlayerDataModel *model = array.firstObject;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.staticImageStr] placeholderImage:XWImageName(@"placeholder")];
    
    cell.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - setter & getter
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
//        _mainTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kSCREEN_WIDTH, kTOPHEIGHT)];
        [_mainTableView registerClass:[BZSubjectCell class] forCellReuseIdentifier:kBZSubjectCellIdentifier];
        
        //MJRefresh
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0;i<136;i++){
            NSString *str =  [NSString stringWithFormat:@"19_dark_00%03d",i];
            [array addObject:XWImageName(str)];
        }
        [header setImages:array forState:MJRefreshStatePulling];
        [header setImages:array duration:2.0 forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _mainTableView.mj_header = header;
        _mainTableView.mj_header.automaticallyChangeAlpha = YES;
    }
    return _mainTableView;
}

@end
