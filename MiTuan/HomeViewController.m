//
//  HomeViewController.m
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeScrollView.h"
#import "SubHomeView.h"
#import "SubHomeSerchView.h"
#import "CityViewController.h"
#import "GDataXMLNode.h"
#import "ShangPinModel.h"
#import "MyTableViewCell.h"
#import "ShangPinViewController.h"
#import "FenLeiViewController.h"
#import "SerchViewController.h"


//团购ID列表
#define TUANGOU_URL @"http://api.dianping.com/v1/deal/get_all_id_list?appkey=6129732649&sign=8214C2FEE52834EA7F8582EDB6020AD24EF49896&city=%E9%83%91%E5%B7%9E"
//郑州团购列表，作为初始化数据
#define ZHENGZHOU_DEAL @"http://api.dianping.com/v1/deal/get_batch_deals_by_id?appkey=6129732649&sign=FC27C54D99137C9334380E6FCE7ADB84D7999074&deal_ids=160-11236223,160-11531562,160-11571859,160-11555058,160-11554466,160-11554235,160-11577358,160-11550062,160-11568708,160-11573767,160-11573653,160-11573308,160-11479889,160-11571486,160-10633326,160-10632074,160-11255804,160-11565894,160-11571117,160-11570325,160-11565247,160-11554049,160-11525019,160-11568293,160-11566365,160-11503802,160-11576916,160-11552334,160-11562204,160-11560214,160-11560673,160-11560648,160-11559458,160-11537559,160-11558516,160-11552113,160-11552527,160-11554046,160-11542525,160-11551816"
//根据商品ID来获得商品数据
#define SHANGPIN_URL @"v1/deal/get_batch_deals_by_id"


#define WINDOW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface HomeViewController ()<MJRefreshBaseViewDelegate,DPRequestDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    //用于地图
    BMKMapView *_mapView;
    BMKMapManager *_manager;
    //用于搜索框
    BMKLocationService* _locationService;
    //用于接收下载的商品数据
    NSMutableData *_tuanData;
    //用于数据库操作
    NSManagedObjectContext *_context;
    //定义一个数组用来储存List
    NSMutableArray *_listArr;
    //定义一个数组储存商品信息
    NSMutableArray *_dataArr;
    //展示商品的表格视图
    UITableView *_tableView;
    //滑动视图
    HomeScrollView *_scollView;
    //名店界面
    SubHomeView *_subhomeView;
    //有个page记录需要展示到第几页
    NSInteger _page;
    //设置page
    UIPageControl * _pageControl;
   //用一个数组来存储大头针
    NSMutableArray *_annotionArr;
}
//用于刷新的成员变量
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@end

@implementation HomeViewController

//重写构造方法，里边做一些初始化的操作
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _tuanData = [[NSMutableData alloc] init];
        _listArr = [[NSMutableArray alloc] init];
        _dataArr = [[NSMutableArray alloc] init];
        _annotionArr = [[NSMutableArray alloc] init];
        
        DPAppDelegate *dele = [DPAppDelegate instance];
        _context = dele.managedObjectContext;
        _page = 1;
        //默认城市为郑州
        self.cityID = @"zhengzhou";
        self.cityName = @"郑州";
        //异步下载 团购数据
        //[self tuanGouDataload];
        [self dataLoad];
    }
    return self;
}

- (void)viewDidLoad {
    //开启一个线程去接受数据  进行耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self tuanGouDataload];
         [self creatMap];
    });
    
    
    self.view.userInteractionEnabled = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    
    //设置刷新操作
    [self setupHeader];
    [self.footView endRefreshing];
    //解决导航遮挡问题
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatUI{
   
    
    
    
    //添加名店界面
    //_subhomeView  = [[SubHomeView alloc] initWithFrame:CGRectMake(0, 230, WINDOW_WEIGHT, 140)];
    //[self.view addSubview:subhomeView];
    _subhomeView  = [[SubHomeView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WEIGHT, 140)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    [_subhomeView addGestureRecognizer:tap1];
  //  _subhomeView.backgroundColor = [UIColor colorWithRed:252/255.0 green:127/255.0 blue:154/255.0 alpha:1.0];
    
    //添加按钮滑动界面
    //_scollView = [[HomeScrollView alloc] initWithFrame:CGRectMake(0, 20, WINDOW_WEIGHT, 210)];
    _scollView = [[HomeScrollView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WEIGHT, 220)];
    
    _scollView.contentSize = CGSizeMake(WINDOW_WEIGHT*2, 220);
    _scollView.pagingEnabled = YES;
    _scollView.showsHorizontalScrollIndicator = NO;
    //[self.view addSubview:scollView];
    _scollView.userInteractionEnabled = YES;
    NSString *str = self.cityName;
    _scollView.delegate = self;
    
   
    
    //设置分类界面的BLOCK用来传值以及跳转界面
    _scollView.block = ^(NSString *cate){
        FenLeiViewController *fenlei = [[FenLeiViewController alloc] init];
        fenlei.city = str;
        fenlei.cate = cate;
        [self.navigationController pushViewController:fenlei animated:YES];
    };
    
    
    
    //表格视图
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 415, WINDOW_WEIGHT, WINDOW_HEIGHT-385-49)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, WINDOW_WEIGHT, WINDOW_HEIGHT-99)];

    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //添加搜索条
    SubHomeSerchView *subSearchView = [[SubHomeSerchView alloc] initWithFrame:CGRectMake(0, 20, WINDOW_WEIGHT, 40)];
    subSearchView.backgroundColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:162/255.0 alpha:0.75];
    subSearchView.userInteractionEnabled = YES;
    [self.view addSubview:subSearchView];
    subSearchView.Tiaozhuan = ^{
        [self tiaoZhuanSearch];
    };
    
 
    
    //添加选择城市按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(5, 25, 45, 32);
    [btn setTitle:@"郑州" forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 100;
    
    //添加地图按钮
    //UIButton *dingweiBtn = [[UIButton alloc] initWithFrame:CGRectMake(325, 25, 32, 32)];
    UIButton *dingweiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dingweiBtn.frame = CGRectMake(333, 25, 35, 35);
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"map_location" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path2];
    [dingweiBtn addTarget:self action:@selector(showBaiduMap:) forControlEvents:UIControlEventTouchUpInside];
    [dingweiBtn setImage:image2 forState:UIControlStateNormal];
    [self.view addSubview:dingweiBtn];
    
    
    
   
}
//名店界面
-(void)tap1{
    FenLeiViewController *fenlei = [[FenLeiViewController alloc] init];
    fenlei.city = self.cityName;
    fenlei.cate = @"美食";
    [self.navigationController pushViewController:fenlei animated:YES];
}

//跳转search界面
-(void)tiaoZhuanSearch{
    SerchViewController *ser = [[SerchViewController alloc] init];
    [self.navigationController pushViewController:ser animated:YES];
}

#warning 地图备注：如果要真机调试需要修改setting里边导入的其它库文件，把其换为真机调试！
-(void)creatMap{
    _manager = [[BMKMapManager alloc] init];
    //需要在这里传入百度地图的APPKey
    if([_manager start:@"K0hDwu6TFfk5we1MealXrYYn" generalDelegate:nil]){
        NSLog(@"创建地图成功");
    }else{
        //在info.plist中添加：Bundle display name,Value里边填APP的名字（Xcode6新建的项目没有此配置，若没有会造成manager start failed）
        NSLog(@"创建地图失败");
    }
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 60,WINDOW_WEIGHT, WINDOW_HEIGHT-60-49)];
    
    _mapView.delegate = self;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.752814, 113.665167);
    DPAppDelegate *delegate = [DPAppDelegate instance];
    delegate.coodinate = coordinate;
    BMKCoordinateRegion regin = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.3, 0.3));
    [_mapView setRegion:regin];
    
    //给地图添加一个长按事件
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    [_mapView addGestureRecognizer:longPress];
    
    //设置地图比例尺级别
    _mapView.zoomLevel = 15;
}



//郑州火车站  经纬度113.665167,34.752814
-(void)showBaiduMap:(UIButton *)btn{
    [self.view addSubview:_mapView];
   
   // _mapView.hidden = NO;
 
     [_mapView removeAnnotations:_annotionArr];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 375, 40)];
    headView.backgroundColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:162/255.0 alpha:1];
    //设置返回button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, 5, 30, 30);
    [headView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(removeMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    
    UIImageView *meiView = [[UIImageView alloc] initWithFrame:CGRectMake(43, 3, 34, 34)];
    meiView.image = [UIImage imageNamed:@"ic_action_home.png"];
    [headView addSubview:meiView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 75, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"百度地图";
    label.textColor = [UIColor whiteColor];
    [headView addSubview:label];
    
    headView.tag = 123;
    //UIAlertView
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"长按地图进行定位" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"点击大头针可以查看周边团购", nil];
    //展示UIAlertView
    [view show];
    [self mapLocation];
}

-(void)removeMap:(UIButton *)btn{
    UIView *view = [self.view viewWithTag:123];
    [view removeFromSuperview];
    //_mapView.hidden = YES;
   
    [_mapView removeFromSuperview];
}

//定位方法
-(void)mapLocation{
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
//#warning 未完成
    /**
     *打开定位服务
     *需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
     *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
     *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
     */
    [_locationService startUserLocationService];
    //显示定位的蓝点
    [_mapView setShowsUserLocation:YES];
    
}





//跳转至城市界面
-(void)btnAction{
    NSLog(@"111");
    CityViewController * cityView = [[CityViewController alloc] init];
    [self.navigationController pushViewController:cityView animated:YES];
    cityView.cityBlock = ^(CityModel *model,NSArray *arr){
        CGFloat lati = [model.weidu floatValue];
        CGFloat longa = [model.jingdu floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, longa);
        _mapView.centerCoordinate = coordinate;
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        [btn setTitle:model.name forState:UIControlStateNormal];
        self.cityID = model.cityID;
        self.cityName = model.name;
        [DPAppDelegate instance].city = model.name;
        _listArr = [arr mutableCopy];
        [_dataArr removeAllObjects];
        [self requestWithPage:_page];
    };
}

-(void)requestWithPage:(NSInteger)page{
     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=(_page-1)*40; i<_page*40; i++) {
        NSLog(@"count = %ld",_listArr.count);
        if (_listArr.count>i) {
            [tempArr addObject:_listArr[i]];
        }else{
            NSLog(@"List表内ID不足！");
            return;
        }
    }
    NSString *str = [tempArr componentsJoinedByString:@","];
    NSString *strr = [NSString stringWithFormat:@"deal_ids=%@",str];
    [self requstDataWithURL:SHANGPIN_URL WithParam:strr];
}

-(void)tuanGouDataload{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:TUANGOU_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = responseObject[@"id_list"];
        _listArr = [arr mutableCopy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}






//数据初始化
-(void)dataInit{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:ZHENGZHOU_DEAL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
#if 0
        //此段 数据用于获取郑州的40个商品列表
        
        NSArray *arr = responseObject[@"id_list"];
        for (int i=5; i<405; i+=10) {
            [_listArr addObject:arr[i]];
        }
        NSString *str = [_listArr componentsJoinedByString:@","];
        NSLog(@"%@",str);
#endif
        NSArray *arr = responseObject[@"deals"];
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
               // NSLog(@"%@",model.address);
                [_context save:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
                [alert show];
            }];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }];
}
//数据加载
-(void)dataLoad{
    
//    NSFetchRequest *requst = [[NSFetchRequest alloc] init];
//    NSEntityDescription *dec = [NSEntityDescription entityForName:@"ShangPinModel" inManagedObjectContext:_context];
//    [requst setEntity:dec];
    
    NSFetchRequest *requst = [[NSFetchRequest alloc] initWithEntityName:@"ShangPinModel"];
    NSMutableArray *arr = [[_context executeFetchRequest:requst error:nil] mutableCopy];
    
    if (arr.count==0) {
        NSLog(@"第一次进入，初始化数据");
        [self dataInit];
    }else{
        for (ShangPinModel *model in arr) {
            [_dataArr addObject:model];
            //需要删除时做次操作
//            [_context deleteObject:model];
//            [_context save:nil];
        }
    }
}

#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count+2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    ShangPinModel *model;
    UITableViewCell *cell1 = [[UITableViewCell alloc] init];
    UITableViewCell *cell2 = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            
            [cell1.contentView addSubview:_scollView];
            //创建分页控制
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200, 325, 20)];
            [cell1.contentView addSubview:_pageControl];
            _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
            _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            _pageControl.numberOfPages = 2;
            [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell1;
            break;
        case 1:
            [cell2.contentView addSubview:_subhomeView];
            return cell2;
            break;
        default:
            //NSLog(@"%ld",_dataArr.count);
            if(_dataArr.count>=2){
             model = _dataArr[indexPath.row-2];
            [cell setModel:model];
            }else{
                return cell1;
            }
    }

    return cell;
}

-(void)pageAction:(UIPageControl *)page{
    [_scollView setContentOffset:CGPointMake(page.currentPage*375, 0)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 220;
        case 1:
            return 140;
        default:
            return 120;
    }
}

//跳转至商品详情界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>1){
        if (_dataArr.count>indexPath.row-2) {
            ShangPinModel *model = _dataArr[indexPath.row-2];
            ShangPinViewController *scv = [[ShangPinViewController alloc] initWithID:model.deal_id];
            [self.navigationController pushViewController:scv animated:YES];
        }
       
        
    }
}

-(void)requstDataWithURL:(NSString *)url WithParam:(NSString *)param{
    [[[DPAppDelegate instance] dpapi] requestWithURL:url paramsString:param delegate:self];
}


#pragma mark - DPRequestDelegate方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSArray *arr = result[@"deals"];
    if (arr.count==0) {
        NSLog(@"返回的是搜索结果");
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
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
            [_tableView reloadData];
            NSLog(@"adress = %@",model.address);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"加载数据失败，请检查网络");

        }];
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}




//下拉刷新 上拉加载

//-(MJRefreshHeaderView *)headView{
//    
//    if (_headView==nil) {
//        
//        //实例化MJRefreshHeaderView
//        _headView = [[MJRefreshHeaderView alloc] init];
//        //设置MJRefreshHeaderView所加载的控件
//        _headView.scrollView = _tableView;
//        //设置代理
//        _headView.delegate = self;
//        
//    }
//    
//    return _headView;
//    
//}

-(MJRefreshFooterView *)footView{
    
    if (_footView == nil) {
        
        //实例化MJRefreshFooterView
        _footView = [[MJRefreshFooterView alloc] init];
        _footView.scrollView = _tableView;
        _footView.delegate = self;
    }
    
    return _footView;
    
}
#pragma mark-
//刷新调用的方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
//    if (refreshView==_headView) {
//        [_dataArr removeAllObjects];
//        [self requestWithPage:1];
//    }else{
        _page++;
        [self requestWithPage:_page];
  //  }
    //[_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.5];
}

#pragma mark - 百度地图的代理方法
//长按时确定一个coordinate
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    [DPAppDelegate instance].coodinate = coordinate;
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.title = @"点击查看周边团购";
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    [_annotionArr addObject:annotation];
}

#define SEARCH_STORE_URL @"v1/deal/find_deals"

-(void)longPressAction:(UIGestureRecognizer *)ges{
//    [_mapView removeFromSuperview];
//    
//    
//   
//    
//    CLLocationCoordinate2D coodinate = [DPAppDelegate instance].coodinate;
//    UIView *view = [self.view viewWithTag:123];
//    [view removeFromSuperview];
//    [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"city=%@&latitude=%f&longitude=%f",self.cityName,coodinate.latitude,coodinate.longitude]];
//    NSLog(@"%f      %f",coodinate.latitude,coodinate.longitude);
//    [_dataArr removeAllObjects];
}

//自定义大头针
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"bmk"];
    if (annotationView==nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"bmk"];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5)); annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"annPin"];
    annotationView.draggable = NO;
    return annotationView;
}

//大头针被点击，跳转界面
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [_mapView removeFromSuperview];
    
    
    
    
    CLLocationCoordinate2D coodinate = [DPAppDelegate instance].coodinate;
    UIView *view1 = [self.view viewWithTag:123];
    [view1 removeFromSuperview];
    [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"city=%@&latitude=%f&longitude=%f",self.cityName,coodinate.latitude,coodinate.longitude]];
    NSLog(@"%f      %f",coodinate.latitude,coodinate.longitude);
    [_dataArr removeAllObjects];

}


- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    _refreshHeader = refreshHeader;
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_dataArr removeAllObjects];
            [self requestWithPage:1];
            [weakRefreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
        });
    };
    
    // 动画view
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.frame = CGRectMake(30, 45, 40, 40);
    animationView.image = [UIImage imageNamed:@"staticDeliveryStaff"];
    [refreshHeader addSubview:animationView];
    _animationView = animationView;
    
    UIImageView *boxView = [[UIImageView alloc] init];
    boxView.frame = CGRectMake(150, 10, 15, 8);
    boxView.image = [UIImage imageNamed:@"box"];
    [refreshHeader addSubview:boxView];
    _boxView = boxView;
    
    UILabel *label= [[UILabel alloc] init];
    label.text = @"下拉加载最新数据";
    label.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 5, 200, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [refreshHeader addSubview:label];
    _label = label;
    
    // normal状态执行的操作
    refreshHeader.normalStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        refreshView.hidden = NO;
        if (progress == 0) {
            _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            _boxView.hidden = NO;
            _label.text = @"下拉加载最新数据";
            [_animationView stopAnimating];
        }
        
        self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 10, -20 * progress), CGAffineTransformMakeScale(progress, progress));
        self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 90, progress * 35);
    };
    
    // willRefresh状态执行的操作
    refreshHeader.willRefreshStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        _boxView.hidden = YES;
        _label.text = @"放开我，我要为你加载数据";
        _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(10, -20), CGAffineTransformMakeScale(1, 1));
        NSArray *images = @[[UIImage imageNamed:@"deliveryStaff0"],
                            [UIImage imageNamed:@"deliveryStaff1"],
                            [UIImage imageNamed:@"deliveryStaff2"],
                            [UIImage imageNamed:@"deliveryStaff3"]
                            ];
        _animationView.animationImages = images;
        [_animationView startAnimating];
    };
    
    // refreshing状态执行的操作
    refreshHeader.refreshingStateOperationBlock = ^(SDRefreshView *refreshView, CGFloat progress){
        _label.text = @"客官别急，正在加载数据...";
        [UIView animateWithDuration:1.5 animations:^{
            self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
        }];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

#pragma scrollView 代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_scollView) {
        if(scrollView.contentOffset.x==0){
            _pageControl.currentPage = 0;
        }else{
            _pageControl.currentPage = 1;
        }
    }
}
@end












