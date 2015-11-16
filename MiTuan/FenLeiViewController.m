//
//  FenLeiViewController.m
//  MiTuan
//
//  Created by wangZL on 15-4-17.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "FenLeiViewController.h"
#import "MyTableViewCell.h"
#import "AFNetworking.h"
#import "ShangPinModel.h"
#import "DPAppDelegate.h"
#import "ShangPinViewController.h"
//查找商品接口
#define URL_FENLEIONE @"v1/deal/find_deals"

@interface FenLeiViewController ()<UITableViewDataSource,UITableViewDelegate,DPRequestDelegate>
{
    NSMutableArray *_dataArr;
    
    UITableView *table;
}
@end

@implementation FenLeiViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArr  = [[NSMutableArray alloc] init];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    if ([self.cate isEqualToString:@"全部"]) {
        NSString *str = [NSString stringWithFormat:@"city=%@",self.city];
        [self requstDataWithURL:URL_FENLEIONE WithParam:str];
    }else{
        NSString *str = [NSString stringWithFormat:@"city=%@&category=%@",self.city,self.cate];
        [self requstDataWithURL:URL_FENLEIONE WithParam:str];
    }
    // Do any additional setup after loading the view.
    [self creatUI];
}


-(void)creatUI{
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 375, 617-49)];
    table.delegate = self;
    table.dataSource = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"AFStringFromNetwork = %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [table registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
    
    //自定义导航栏
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 375, 50)];
    view.backgroundColor = [UIColor colorWithRed:17/255.0 green:63/255.0 blue:61/255.0 alpha:1.0];
    [self.view addSubview:view];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 250, 30)];
    [view addSubview:lable];
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor redColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = self.cate;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 10, 30, 30);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - tableView代理方法


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ShangPinModel *model = _dataArr[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShangPinModel *model = _dataArr[indexPath.row];
    ShangPinViewController *vc = [[ShangPinViewController alloc] initWithID:model.deal_id];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)requstDataWithURL:(NSString *)url WithParam:(NSString *)param{
    [[[DPAppDelegate instance] dpapi] requestWithURL:url paramsString:param delegate:self];
    
}

#pragma mark - DPRequestDelegate方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSArray *arr = result[@"deals"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSManagedObjectContext *_context = [DPAppDelegate instance].managedObjectContext;
    
    for (NSDictionary *dic in arr) {
        ShangPinModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"ShangPinModel" inManagedObjectContext:_context];
        model.title = dic[@"title"];
        model.deal_id = dic[@"deal_id"];
        model.descri = dic[@"description"];
        model.currentPrice = [NSString stringWithFormat:@"%@",dic[@"current_price"]];
        model.purchase_date = [NSString stringWithFormat:@"%@",dic[@"list_price"]];
        model.address = [dic[@"regions"] firstObject];
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        [manager GET:dic[@"s_image_url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            model.image = responseObject;
            [_dataArr addObject:model];
            [table reloadData];
           // NSLog(@"%@",model.address);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"加载数据失败，请检查网络");
        }];
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"加载数据失败，error = %@",error);
}



@end
