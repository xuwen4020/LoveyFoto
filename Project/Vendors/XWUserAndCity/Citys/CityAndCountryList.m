//
//  CityAndCountryList.m
//  ddddd
//
//  Created by yanll on 16/10/17.
//  Copyright © 2016年 icsoft. All rights reserved.
//

#import "CityAndCountryList.h"
#import <MapKit/MapKit.h>
#import <Masonry/Masonry.h>

@interface CityAndCountryList ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSArray *_dataSource;
    NSMutableArray    *_sortedKeys;
    NSMutableDictionary *_keyData;
    NSMutableArray *_searchData;
    NSString   *_selectedString;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *search;

@end

@implementation CityAndCountryList
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor projectBackGroudColor];
    //导航视图
    UIView *naviView = [[UIView alloc]init];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kStatusBarAndNavigationBarHeight));
    }];
    
    //tittle
    UILabel *title = [[UILabel alloc]init];
    title.text = NSLocalizedString(@"Select City", nil);
    title.textColor = [UIColor projectMainTextColor];
    title.font = FontBold(18);
    title.textAlignment = 1;
    [naviView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(naviView);
        make.bottom.equalTo(naviView).offset(-10);
        make.height.equalTo(@35);
    }];
    
    //backButton
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:XWImageName(@"return_black") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //[backButton setEnlargeEdge:20];
    [naviView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(naviView).offset(15);
        make.bottom.equalTo(naviView).offset(-10);
        make.width.equalTo(@20);
        make.height.equalTo(@30);
    }];
    
    [self yh_setMainSubViews];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)yh_setMainSubViews{
  
    _keyData = [NSMutableDictionary dictionary];
    _sortedKeys = [NSMutableArray array];
    _searchData= [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.search;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
    }];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setupCountryData];
        dispatch_async(dispatch_get_main_queue(), ^{
     
        });
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.search resignFirstResponder];
}
- (void)yh_leftButtonClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeToChoseCity {
    [self.search resignFirstResponder];
    _selectedCityBlock ? _selectedCityBlock(_selectedString) : nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCountryData{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"csv"];
    NSString *strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    if (!strFile) {
        NSLog(@"Error reading file.");
    }
    NSArray *arrayCountry = [[NSArray alloc] init];
    arrayCountry = [strFile componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *dictionaryOfPlaces = [[NSMutableDictionary alloc]init];
    
    NSArray *dataComponents = [[NSArray alloc] init];
    for(NSString *countryname in arrayCountry) {
        if (countryname.length > 0) {
            dataComponents = [countryname componentsSeparatedByString:@","];
            
            double latitude = [(NSString*)[dataComponents objectAtIndex:3] doubleValue];
            double longitude = [(NSString*)[dataComponents objectAtIndex:4] doubleValue];
            NSString *description = [NSString stringWithFormat:@"%@,%@",[dataComponents objectAtIndex:0], [dataComponents objectAtIndex:1]];
            CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
            if (dictionaryOfPlaces[description]) {
                [dictionaryOfPlaces[description] addObject:newLocation];
            }
            else{
                NSMutableArray * locations = [[NSMutableArray alloc]initWithObjects:newLocation, nil];
                [dictionaryOfPlaces setValue:locations forKey:description];
            }
        }
    }
    
    _dataSource = dictionaryOfPlaces.allKeys;
    [self handleArray:[_dataSource sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
}

- (void)handleArray:(NSArray *)array {
    
    [_keyData removeAllObjects];
    [_sortedKeys removeAllObjects];
    
    for (NSString *font in array) {
        NSString *first_ch = [font substringToIndex:1];
        
        NSMutableArray *fontsGroup = [NSMutableArray arrayWithArray:_keyData[first_ch]];
        [fontsGroup addObject:font];
        [_keyData setObject:fontsGroup forKey:first_ch];
        
    }
    
//    _sortedKeys = [NSMutableArray arrayWithArray:array  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    _sortedKeys = [NSMutableArray arrayWithArray:[_keyData.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sortedKeys.count;
}

//设置侧边栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sortedKeys;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sortedKeys[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _sortedKeys[section];
    NSArray *fonts = [NSArray arrayWithArray:_keyData[key]];
    return fonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = cell.textLabel.text = _keyData[_sortedKeys[indexPath.section]][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedString = _keyData[_sortedKeys[indexPath.section]][indexPath.row];
    [self completeToChoseCity];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [_searchData removeAllObjects];
    if (searchText!=nil && searchText.length>0) {
        
        for (NSString *tempStr in _dataSource) {
            NSRange substringRange = [tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (substringRange.location == 0) {
                [_searchData addObject:tempStr];
            }
        }
        [self handleArray:_searchData];
    }
    else
    {
        [self handleArray:_dataSource];
    }
}
- (UISearchBar *)search {
    if (!_search) {
        _search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
        _search.delegate = self;
    }
    return _search;
}

@end
