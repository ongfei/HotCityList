
//
//  CitySelectController.m
//  SinoMT
//
//  Created by SINOKJ on 16/6/21.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "CitySelectController.h"
#import "CityModel.h"
#import "CityTableViewCell.h"
#import <YYModel.h>
#import <MJExtension.h>

@interface CitySelectController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) NSMutableDictionary *cityDict;
@property (nonatomic, strong) NSMutableArray *totleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchView;
@property (nonatomic, strong) NSMutableArray *headArr;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic, assign) BOOL isSearch;



@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.cityDict = [NSMutableDictionary dictionary];
    self.searchArr = [NSMutableArray array];
    self.totleArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestData];
    [self prepareLayoutSubviews];
}
- (void)requestData {
    
    NSDictionary *sourceDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
    
    self.cityModel = [CityModel mj_objectWithKeyValues:sourceDic];
    [self sortData];
    [self.totleArray addObjectsFromArray:self.cityModel.objects];
}
// mark - 将首字母相同的放在一起
- (void)sortData {
    for (Objects *obj in self.cityModel.objects) {
        
        NSMutableArray *letterArr = _cityDict[obj.initial];
        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [_cityDict setObject:letterArr forKey:obj.initial];
        }
        //将新数据放到数组里
        [letterArr addObject:obj];
    }
    [self.tableView reloadData];
}
#pragma mark - 获得所有的key值并排序，并返回排好序的数组
- (NSMutableArray *)headArr {
    [_headArr removeAllObjects];
    NSArray *keys = [_cityDict allKeys];
    _headArr = [NSMutableArray arrayWithArray:[keys sortedArrayUsingSelector:@selector(compare:)]];
    [_headArr insertObject:@"热门城市" atIndex:0];
    [_headArr insertObject:@"定位城市" atIndex:0];
    return _headArr;
}

- (void)prepareLayoutSubviews {
    self.searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 44)];
    _searchView.delegate = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView  = _searchView;
    [_tableView registerClass:[CityTableViewCell class] forCellReuseIdentifier:@"CityTableViewCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor redColor];
    [self.view addSubview:_tableView];
}

// UISearchBar得到焦点并开始编辑时，执行该方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_tableView reloadData];
    
    [searchBar setShowsCancelButton:YES animated:YES];
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.isSearch = NO;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.searchView  setShowsCancelButton:NO animated:YES];
        [self.searchView resignFirstResponder];
        
    } completion:^(BOOL finished) {
        searchBar.text = nil;
    }];
    [_tableView reloadData];
}
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:searchBar textDidChange:searchBar.text];
}
// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    BOOL isSearch = YES;//有编辑内容时为YES
    if (searchText.length <= 0) {
        isSearch = NO;//被清空时为NO
    }
    NSString *searchStr = self.searchView.text;
    [_searchArr removeAllObjects];//清空searchDataArr，防止显示之前搜索的结果内容
    //把这个文本与数据源进行比较
    //把数据源中类似的数据取出，存入searchDataArr
    for (NSInteger i= 0;i < self.totleArray.count ; i ++)
    {
        Objects *model = self.totleArray[i];
        searchStr = [searchStr lowercaseString];//转换成小写
        BOOL isHas = [model.name hasPrefix:searchStr];//判断model.city_name是否以字符串searchStr开头
        if(isHas)
        {
            [self.searchArr addObject:model];
        }else{
            isHas = [model.phonetic hasPrefix:searchStr];
            if (isHas) {
                [self.searchArr addObject:model];
            }
        }
    }
    if (searchStr.length>0) {
        self.isSearch = YES;
        
    }else{
        self.isSearch = NO;
    }
    [self.tableView reloadData];
    
}

- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}

-(BOOL)isZimuWithstring:(NSString *)string
{
    NSString* number=@"^[A-Za-z]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return  [numberPre evaluateWithObject:string];
}

#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 1;
    }else {
        
        return self.headArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchArr.count;
    }else {
        if (section==0||section==1) {
            return 1;
        }else {
            return [self.cityDict[self.headArr[section]] count];
        }
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.headArr[section];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44;
    }else {
        if(indexPath.section==0)
        {
            return 60;
        }
        else if (indexPath.section==1)
        {
            return self.cityModel.hot.count % 3 == 0 ? 50* self.cityModel.hot.count/3 : 50* (self.cityModel.hot.count/3 + 1);
        }
        else
        {
            return 44;
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchcell"];
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchcell"];
        }
        Objects *obj = self.searchArr[indexPath.row];
        cell.textLabel.text = obj.name;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        return cell;
        
    }else {
        if(indexPath.section<2)
        {
            CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell" forIndexPath:indexPath];
            NSMutableArray *arr = [NSMutableArray array];
            Hot *hot = [[Hot alloc] init];
            hot.name = @"北京市";
            [arr insertObject:hot atIndex:0];
            if (indexPath.section == 0) {
                cell.hotModel = arr;
            }else {
                cell.hotModel = self.cityModel.hot;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.didSelectedBtn = ^(NSString *code, NSString *cityName){
                NSLog(@"1");
            };
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            NSArray *array = self.cityDict[self.headArr[indexPath.section]];
            Objects *obj = array[indexPath.row];
            cell.textLabel.text = obj.name;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
            return cell;
        }
        
        return nil;
    }
    return nil;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return nil;
    }else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.headArr];
        [arr removeObjectAtIndex:0];
        [arr removeObjectAtIndex:0];
        [arr insertObject:UITableViewIndexSearch atIndex:0];
        return arr;
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //此方法返回的是section的值
    if(index==0)
    {
        [tableView setContentOffset:CGPointZero animated:YES];
        
        return -1;
    }
    else
    {
        return index+1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Objects *obj;
    if (self.isSearch) {
        obj = self.searchArr[indexPath.row];
    }else {
        NSArray *array = self.cityDict[self.headArr[indexPath.section]];
        obj = array[indexPath.row];
    }
    self.cityBlock(obj.name,obj.code);
    [self.navigationController popViewControllerAnimated:YES];
}

@end


