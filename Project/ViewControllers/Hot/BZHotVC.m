//
//  BZHotVC.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZHotVC.h"
#import "BZHotCell.h"

@interface BZHotVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation BZHotVC
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

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

- (void)baseConstraintsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vipChangedreload) name:APP_EVNET_PURCHASE_VIP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataReload) name:APP_EVNET_UPLOAD_DATA object:nil];
}

- (void)vipChangedreload
{
    [self.mainTableView reloadData];
}

- (void)loadDataReload
{
    [self.mainTableView reloadData];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZHotCell *cell = [tableView dequeueReusableCellWithIdentifier:kBZHotCellIdentifier forIndexPath:indexPath];
    cell.eventVC = self.parentVC;
    switch (indexPath.section) {
        case 0:
        {
            cell.dataArray = [BZDataTool sharedBZDataTool].hotRecommenceArray;
        }
            break;
        case 1:
        {
            cell.dataArray = [BZDataTool sharedBZDataTool].hotAnimalArray;
        }
            break;
        case 2:
        {
            cell.dataArray = [BZDataTool sharedBZDataTool].hotPeopleArray;
        }
            break;
        default:
        {
            cell.dataArray = [BZDataTool sharedBZDataTool].hotXXXArray;
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHOT_CELL_HEIGHT + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[NSLocalizedString(@"RECOMMEND", nil) ,NSLocalizedString(@"ANIMAL", nil),NSLocalizedString(@"PEOPLE", nil),NSLocalizedString(@"FOOD", nil)];
    UIView *headView = [[UIView alloc]init];
    [headView xwDrawCornerWithRadiuce:0];
    
    UILabel *headLabel = [[UILabel alloc]init];
    [headLabel commonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] aliment:NSTextAlignmentLeft];
    headLabel.text = array[section];
    
    UIView *lineView = [[UIView alloc]init];
    [lineView xwDrawCornerWithRadiuce:2.5];
    lineView.backgroundColor = [UIColor xwColorWithHexString:@"#00CEEC"];
    
    [headView addSubview:headLabel];
    [headView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.centerY.equalTo(headLabel);
        make.width.equalTo(@5);
        make.height.equalTo(@20);
    }];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(8);
        make.bottom.equalTo(headView).offset(-15);
        make.height.equalTo(@14);
    }];
    
    return headView;
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
    NSLog(@"点击了%ld行",indexPath.row);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
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
        [_mainTableView registerClass:[BZHotCell class] forCellReuseIdentifier:kBZHotCellIdentifier];
    }
    return _mainTableView;
}

//- (void)setDataArray:(NSArray<LCPPlayerDataModel *> *)dataArray
//{
//    _dataArray = dataArray;
//    [self.mainTableView reloadData];
//}

@end
