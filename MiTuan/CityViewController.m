//
//  CityViewController.m
//  MiTuan
//
//  Created by wangZL on 15-4-13.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "CityViewController.h"
#import "AFNetworking.h"

#define WINDOW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
//获得全国支持团购的城市列表
#define CITY_URL @"http://www.meituan.com/api/v2/divisions"
//根据城市获得商品ID列表
#define CITY_LIST @"v1/deal/get_all_id_list"
@interface CityViewController ()<UIActionSheetDelegate,DPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *_dataArr;
    NSManagedObjectContext *_context;
    UITableView *_tableView;
    UISearchDisplayController *_disCtl;//必须作为成员变量
    NSMutableArray *_searchArr; //储存搜索结果
    
    UISearchBar *bar;
    
    CityModel *_model;
}
@end

@implementation CityViewController


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//view高140
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       //数组初始化
        _dataArr = [[NSMutableArray alloc] init];
        _searchArr = [[NSMutableArray alloc] init];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, WINDOW_WEIGHT, WINDOW_HEIGHT-104-49)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self creatNavigationBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self dataLoad];
   
    [self.view addSubview:_tableView];
}


-(void)creatNavigationBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WINDOW_WEIGHT, 44)];
    view.backgroundColor = [UIColor colorWithRed:3/255.0 green:101/255.0 blue:151/255.0 alpha:1.0];
    
    [self.view addSubview:view];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 10, 30, 30);
    [view addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 375, 30)];
    label.text = @"城市列表";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
}

-(void)backAction:(UIButton *)tb{
    [self.navigationController popViewControllerAnimated:YES];
}


//加载数据
-(void)dataLoad{
    
    //数据库部分
    DPAppDelegate *dele = [DPAppDelegate instance];
    _context = dele.managedObjectContext;
    //创建数据请求
    NSFetchRequest *requst = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityModel" inManagedObjectContext:_context];
    //设置请求实体
    [requst setEntity:entity];
    
    
    
    //执行获取数据请求，返回数组
    NSMutableArray *mutablFetchResult = [[_context executeFetchRequest:requst error:nil] mutableCopy];
    if (mutablFetchResult.count == 0) {
        NSLog(@"加载数据到数据库");
        [self initCoredata];
        [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:10];
    }else{
        // NSLog(@"%ld",mutablFetchResult.count);
        
        for (CityModel  *model  in mutablFetchResult) {
            [_dataArr addObject:model];
            
            
        }
       [_tableView reloadData];
    }
    
    //搜索框部分
    
    //实例化一个UISearchBar
    bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, WINDOW_WEIGHT, 40)];
    bar.placeholder = @"输入城市名...";
   [self.view addSubview:bar];
    //contentsController搜索功能建立在哪个控制器上
    _disCtl = [[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
    //设置搜索控制器的代理
    _disCtl.delegate = self;
    _disCtl.searchResultsDelegate = self;
    _disCtl.searchResultsDataSource = self;
}


//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}

-(void)initCoredata{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:CITY_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析json数据
        NSArray *data = responseObject[@"divisions"];
        
        for (NSDictionary *dic in data) {
            //将解析出来的数据 存入数据库中!
            CityModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"CityModel" inManagedObjectContext:_context];
            model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
            model.cityID = [NSString stringWithFormat:@"%@",dic[@"id"]];
            //进一步解析经纬度
            NSDictionary *dic1 = dic[@"location"];
            model.weidu = [NSString stringWithFormat:@"%@",dic1[@"latitude"]];
            model.jingdu = [NSString stringWithFormat:@"%@",dic1[@"longitude"]];
            [_dataArr addObject:model];
            [_context save:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return _dataArr.count;
    }
    return _searchArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CityModel *model;
    if (tableView == _tableView) {
        model = _dataArr[indexPath.row];
    }else{
        model = _searchArr[indexPath.row];
    }
    
    
    cell.textLabel.text = model.name;
    return cell;
}
//创建城市的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int a='A'; a<='Z'; a++) {
        [arr addObject:[NSString stringWithFormat:@"%c",a]];
    }
    return arr;
}

//过滤搜索结果
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    //清空数组
    [_searchArr removeAllObjects];
    for (CityModel *model in _dataArr) {
        if ([model.name rangeOfString:searchString].location != NSNotFound) {
            [_searchArr addObject:model];
        }
    }
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //self.navigationController.navigationBarHidden = YES;
    if (tableView==_tableView) {
        _model = _dataArr[indexPath.row];
    }else{
         _model = _searchArr[indexPath.row];
        
    }
//    NSString *str = [NSString stringWithFormat:@"city=%@",_model.name];
//    [self requstDataWithURL:CITY_LIST WithParam:str];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    UIView *view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    view1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [self.view addSubview:view1];
    view1.tag = 223;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    view.frame = CGRectMake(100, 100, 60, 60);
    [view startAnimating];
    [self.view addSubview:view];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"温馨提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载商品表单.." otherButtonTitles: nil];
    [action showInView:self.view];
    action.tag = 213;
    
}



-(void)requstDataWithURL:(NSString *)url WithParam:(NSString *)param{
    [[[DPAppDelegate instance] dpapi] requestWithURL:url paramsString:param delegate:self];
}


#pragma mark - DPRequestDelegate方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //NSLog(@"%@",result);
        NSArray *cityArr = result[@"id_list"];
    //    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //    for(int i=0;i<20;i++){
    //        [arr addObject:cityArr[i]];
    //    }
    //    NSString *str = [arr componentsJoinedByString:@","];
    //    NSLog(@"%@",str);
    if (self.cityBlock) {
        self.cityBlock(_model,cityArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"加载数据失败，error = %@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSString *str = [NSString stringWithFormat:@"city=%@",_model.name];
        [self requstDataWithURL:CITY_LIST WithParam:str];
    }
    UIView *view = [self.view viewWithTag:223];
    [view removeFromSuperview];
}

@end
