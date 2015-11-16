//
//  ShangPinViewController.m
//  MiTuan
//
//  Created by wangZL on 15-4-16.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ShangPinViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "MyPayHeader.h"


//商品详情接口
#define DEAL_LIST @"v1/deal/get_single_deal"


@interface ShangPinViewController ()<DPRequestDelegate>
{
    UIScrollView *_scrollView;
    UILabel *_lablePrice;
    UILabel *_lableYuanPrice;
    UIImageView *_imageView;
   
    //团购详情
    UILabel *_lableDes;
    //已售
    UILabel *_lableCount;
    //截止时间
    UILabel *_lableTime;
    //details
    UILabel *_lableDetails;
    
    //团购title
    UILabel *_lableTitle;
    
    //店铺地址
    UILabel *_lableAdd;
    //店铺名称
    UILabel *_lableName;
    //通知
    UILabel *_lableTip;
    //商品展示：
   UIView *_scroll;
    //价格视图
    UIView *view1;
    //介绍视图
    UIView *view2;
    //
    UIView *view3;
}
@end

@implementation ShangPinViewController

-(instancetype)initWithID:(NSString *)dealID{
    if (self = [super init]) {
        self.dealID = dealID;
       
       
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
     NSString *str = [NSString stringWithFormat:@"deal_id=%@",self.dealID];
     [self requstDataWithURL:DEAL_LIST WithParam:str];
    // Do any additional setup after loading the view from its nib.
 
}

-(void)creatUI{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 375, 40)];
    headView.backgroundColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:162/255.0 alpha:0.75];
    //设置返回button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, 5, 30, 30);
    [headView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    
    UIImageView *meiView = [[UIImageView alloc] initWithFrame:CGRectMake(43, 3, 34, 34)];
    meiView.image = [UIImage imageNamed:@"ic_action_home.png"];
    [headView addSubview:meiView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 75, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"团购详情";
    label.textColor = [UIColor whiteColor];
    [headView addSubview:label];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 375, 667-49-60)];
    _scrollView.contentSize = CGSizeMake(375, 940);
    _scrollView.backgroundColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:0.2];
    [self.view addSubview:_scrollView];

    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 180)];
    [_scrollView addSubview:_imageView];
    
    UIView *lableView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 375, 30)];
    lableView.backgroundColor = [UIColor blackColor];
    lableView.alpha = 0.4;
    [_scrollView addSubview:lableView];
    
    _lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
    _lableTitle.textColor = [UIColor whiteColor];
    [lableView addSubview:_lableTitle];
    
    
    //价格相关视图  高度从180开始
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 375, 360)];
    
    [_scrollView addSubview:view1];
    view1.backgroundColor = [UIColor colorWithRed:45/255.0 green:163/255.0 blue:158/255.0 alpha:0.9];
    _lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 42, 40)];
    _lablePrice.font = [UIFont systemFontOfSize:20];
    _lablePrice.textColor = [UIColor redColor];
    _lablePrice.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:_lablePrice];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(240, 5, 120, 40);
    btn.backgroundColor = [UIColor colorWithRed:253/255.0 green:126/255.0 blue:12/255.0 alpha:1.0];
    [btn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ZhiFuAciton:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor redColor];
    lable.text = @"￥";
    [view1 addSubview:lable];
    
    _lableYuanPrice = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 30, 18)];
    _lableYuanPrice.font = [UIFont systemFontOfSize:12];
    _lableYuanPrice.textColor = [UIColor colorWithRed:3/255.0 green:101/255.0 blue:151/255.0 alpha:1.0];
    _lableYuanPrice.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:_lableYuanPrice];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(77, 24,26 , 1)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [view1 addSubview:view];
    
    //详情
    _lableDes = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 355, 55)];
    _lableDes.numberOfLines = 0;
    [view1 addSubview:_lableDes];
    
   
  
    
    //描述
    _lableDetails = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 355, 250)];
    _lableDetails.numberOfLines = 0;
    [view1 addSubview:_lableDetails];
    view1.backgroundColor = [UIColor whiteColor];
    
    //店铺相关 高度从550开始
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 550, 375, 140)];
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view2];
    
    _lableName = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 60)];
    [view2 addSubview:_lableName];
    
    _lableAdd = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 375, 30)];
    _lableAdd.font = [UIFont systemFontOfSize:13];
    _lableAdd.textColor = [UIColor grayColor];
    [view2 addSubview:_lableAdd];
    
    _lableCount = [[UILabel alloc] initWithFrame:CGRectMake(8, 90, 100, 34)];
    [view2 addSubview:_lableCount];
    
    _lableTime = [[UILabel alloc] initWithFrame:CGRectMake(128, 90, 200, 34)];
    [view2 addSubview:_lableTime];
    
    view2.backgroundColor = [UIColor whiteColor];
    
    UILabel *lableZhanshi = [[UILabel alloc] initWithFrame:CGRectMake(10, 700, 60, 20)];
    lableZhanshi.text = @"团购展示";
    lableZhanshi.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:lableZhanshi];
    
    //note  高度从700开始
    view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 720, 375, 260)];
    view3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view3];
    
    _scroll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 260)];
    [view3 addSubview:_scroll];
    
    //虚线
    UIImageView *fenge = [[UIImageView alloc] initWithFrame:CGRectMake(10, 105, 355, 20)];
    fenge.image = [UIImage imageNamed:@"分割线.gif"];
    [view1 addSubview:fenge];
  //  xuxian.backgroundColor = [UIColor redColor];

   // view1.backgroundColor = [UIColor colorWithRed:131/255.0 green:175/255.0 blue:155/255.0 alpha:1.0];
}

-(void)back:(UIButton *)send{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requstDataWithURL:(NSString *)url WithParam:(NSString *)param{
    [[[DPAppDelegate instance] dpapi] requestWithURL:url paramsString:param delegate:self];
    
}
/*
 支付业务流程
 1.用户使用咱们的App进行支付（构建订单数据并RSA签名）
 2.咱们的App调用支付宝的客户端
 3.支付宝客户端请求支付宝服务器完成支付（构建业务数据）
 4.支付宝服务器将处理结果分别反馈给咱们App对应的服务器和支付宝客户端
 5.支付宝客户端将结果返回到咱们的App
 */
-(void)ZhiFuAciton:(UIButton *)sender{
    NSLog(@"开始抢购");
    Order *order = [[Order alloc] init];
    //签约成功后 支付宝自动分配
    order.partner = PartnerID;
    order.seller = SellerID;
    
    //订单ID(由商家自行决定)
    order.tradeNO = @"123321";
    order.productName = _lableTitle.text;
    order.productDescription = _lableDes.text;
    
    //商品价格
    order.amount = _lablePrice.text;
    //支付宝服务器主动通知商户网站里指定的地址
    order.notifyURL = @"http://www.baidu.com";
    //固定值
    order.service = @"mobile.securitypay.pay";
    //默认为1  商品购买
    order.paymentType = @"1";
    //字符编码
    order.inputCharset = @"utf-8";
    //未付款交易的超过时间  超时交易自动关闭
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //支付宝回调APP
    NSString *appScheme = @"MiTuan";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥将商户信息签名，外部商户可以根据情况存放私钥和签名，只需要遵循RSA签名规范并将签名字符串base64编码和UrlEncode
    id<DataSigner>singer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [singer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串，请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


#pragma mark - DPRequestDelegate方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"%@",result);
    NSArray *dealsArr = result[@"deals"];
    NSDictionary *dic = [dealsArr firstObject];
    _lableTitle.text = dic[@"title"];
   
    _lablePrice.text = [NSString stringWithFormat:@"%@",dic[@"current_price"]];
    
    _lableYuanPrice.text = [NSString stringWithFormat:@"%@",dic[@"list_price"]];
   
    _lableDes.text = dic[@"description"];
   
    _lableCount.text = [NSString stringWithFormat:@"销量：%d",arc4random()%1000+200];
   
    _lableTime.text = [NSString stringWithFormat:@"截止时间：%@",dic[@"purchase_deadline"]];
    NSString *url = dic[@"image_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url]];
    _lableDetails.text = dic[@"details"];
    
    //动态适应字数
    CGSize size =  [_lableDetails.text boundingRectWithSize:CGSizeMake(300, 20000) options:1 attributes:@{NSFontAttributeName:_lableDetails.font} context:nil].size;
    _lableDetails.frame = CGRectMake(_lableDetails.frame.origin.x, _lableDetails.frame.origin.y+15, 355, size.height);
    NSLog(@"size.height == %f",size.height);
    
    view1.frame = CGRectMake(view1.frame.origin.x, view1.frame.origin.y, 375, _lableDetails.frame.origin.y+_lableDetails.frame.size.height+20);
    NSLog(@"view1.origin.y == %f",view1.frame.size.height);
    
    view2.frame = CGRectMake(view2.frame.origin.x, view1.frame.origin.y+view1.frame.size.height+30, view2.frame.size.width, view2.frame.size.height);
    NSLog(@"view2.origin.y == %f",view2.frame.origin.y);
    
    view3.frame = CGRectMake(view3.frame.origin.x, view2.frame.origin.y+view2.frame.size.height, view3.frame.size.width, view3.frame.size.height);
    
    
    NSArray *busineArr = dic[@"businesses"];
    NSDictionary *dic3 = [busineArr firstObject];
    //店铺地址
    _lableAdd.text = [NSString stringWithFormat:@"地址：%@",dic3[@"address"]];
    //店铺名称
    _lableName.text = [NSString stringWithFormat:@"店铺名称：%@",dic3[@"name"]];
    NSArray *imageArr = dic[@"more_image_urls"];
    UIImageView *imageView;
    for (int i=0; i<imageArr.count; i++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*270, 375, 260)];
        NSString *path = imageArr[i];
        [imageView setImageWithURL:[NSURL URLWithString:path]];
        [_scroll addSubview:imageView];
    }
    if (imageArr.count==0) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 260)];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
    }
    _scroll.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, 375, 260*imageArr.count);
    
    _scrollView.contentSize = CGSizeMake(375, view3.frame.origin.y+270*imageArr.count);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"加载数据失败，error = %@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
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
