//
//  SearchResultController.m
//  MiTuan
//
//  Created by wangZL on 15/4/30.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SearchResultController.h"
#import "MyTableViewCell.h"
#import "AFNetworking.h"
#import "ShangPinModel.h"
#import "DPAppDelegate.h"
#import "ShangPinViewController.h"

#define URL_FENLEIONE @"v1/deal/find_deals"
@interface SearchResultController ()<UITableViewDataSource,UITableViewDelegate,DPRequestDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArr;
    
    UITableView *table;
}
@end

@implementation SearchResultController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArr  = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requstDataWithURL:URL_FENLEIONE WithParam:[NSString stringWithFormat:@"city=%@&keyword=%@",[DPAppDelegate instance].city,self.keyword]];
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    //设置背景图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 375, 40)];
    backView.backgroundColor = [UIColor colorWithRed:25/255.0 green:182/255.0 blue:158/255.0 alpha:1.0];
    [self.view addSubview:backView];
    
    //设置返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 6, 30, 30);
    [backView addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 215, 40)];
    label.text = @"搜索结果如下";
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    
    //设置tableView
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 375, 607-49)];
    table.delegate = self;
    table.dataSource = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"AFStringFromNetwork = %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [table registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
}


//返回
-(void)backAction:(UIButton *)tb{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView代理方法


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
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
    NSString *count =  [NSString stringWithFormat:@"%@",result[@"count"]];
    if ([count isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无此数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }];
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}



#pragma mark - alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //[self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
