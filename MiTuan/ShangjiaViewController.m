//
//  ShangjiaViewController.m
//  MiTuan
//
//  Created by xieyoulei on 15/4/21.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ShangjiaViewController.h"
#import "ShangJiaCell.h"
#import "ShangJiaModel.h"
#import "UIImageView+AFNetworking.h"
#import "MyCollectionViewCell.h"
#import "DOPDropDownMenu.h"
#import "DPAppDelegate.h"
#import "OSBlurSlideMenu.h"
#import "ShangXQingController.h"
#import "ShangImageController.h"

//搜索商户的接口
#define SEARCH_STORE_URL @"v1/business/find_businesses"
//获取支持商户搜索的城市下属区域
#define STORE_REGIONS @"v1/metadata/get_regions_with_businesses"
//获取商户分类
#define STORE_FENLEI @"v1/metadata/get_categories_with_businesses"
@interface ShangjiaViewController ()<UITableViewDataSource,UITableViewDelegate,DPRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    //储存数据的数组
    NSMutableArray *_dataArr;
    UITableView *_tableView;
    //排序选项表格
   // UITableView *_sortTableView;
    //分类选项表格
   // UITableView *_cateTableView;
    //城市选项表格
  //  UITableView *_cityTableView;
    //九宫格布局视图
    UICollectionView *_collectionView;
    //附加阴影视图
    UIView *_yinYingView;
    //储存排序方法的数组
    NSArray *_sortArr;
    //设置flag来判断当前按钮需要做的操作
    BOOL _flag1;
    BOOL _flag2;
    BOOL _flag3;
    //存储区域的列表
    NSMutableArray *_regionArr;
    //分类列表
    NSMutableArray *_cateArr;
    
    //将自定义下拉框设置为成员变量
    DOPDropDownMenu *_menu;
    //subCateArr来存储下属分类的子分类
    NSMutableArray *_subCateArr;
    
    //uiimageView加载动画
    UIImageView *_imageVIew;
}
@end
//郑州火车站  经纬度113.665167,34.752814
@implementation ShangjiaViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArr = [[NSMutableArray alloc] init];
        _sortArr = @[@"智能排序",@"销量最高 ",@"人均最低",@"离我最近"];
        
        _regionArr = [[NSMutableArray alloc] init];
        [_regionArr addObject:@"全城"];
        
        _cateArr = [[NSMutableArray alloc] init];
        [_cateArr addObject:@"全部分类"];
        
        _subCateArr = [[NSMutableArray alloc] init];
        NSArray *arr = [NSArray arrayWithObject:@"全部分类"];
        [_subCateArr addObject:arr];
        self.coodinate = CLLocationCoordinate2DMake(34.752814, 113.665167);
    }
    return self;
}


- (void)viewDidLoad {
    [self requstDataWithURL:STORE_REGIONS WithParam:[NSString stringWithFormat:@"city=%@",[DPAppDelegate instance].city]];
   
    [self requstDataWithURL:STORE_FENLEI WithParam:[NSString stringWithFormat:@"city=%@",[DPAppDelegate instance].city]];
    [super viewDidLoad];
    
    [self creatUI];
    
}

-(void)creatUI{
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 375, 44)];
//    imageView.image = [UIImage imageNamed:@"greenB.png"];
//    [self.view addSubview:imageView];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 375, 44)];
    lable.text = @"商家";
    lable.backgroundColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:162/255.0 alpha:0.75];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:lable];
    lable.textAlignment = NSTextAlignmentCenter;
    // 添加下拉菜单
    
    _menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    //布局collectionView
    //collectionView布局e类
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    //cell之间的上下边距
    layout.minimumLineSpacing = 0;
    //cell之间的左右边距
    layout.minimumInteritemSpacing = 0;
    //设置collectionView滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //每个cell的大小，这个大小在代理中也可以设置
    layout.itemSize = CGSizeMake(185, 233);
    //用layout来创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, 375, 667-108-49) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:169/255.0 alpha:0.9];
    [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    //创建加载动画
    _imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 375, 667-108-49)];
    NSArray *imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"progress_loading_image_01.png"], [UIImage imageNamed:@"progress_loading_image_02.png"], nil];
    _imageVIew.animationImages = imageArr;
    _imageVIew.animationDuration = 0.25;
    [_imageVIew startAnimating];
    [self.view addSubview:_imageVIew];
    
     [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f",self.coodinate.latitude,self.coodinate.longitude]];
}

//-(void)btn3Action:(UIButton *)btn{
//    if (_flag3) {
//        [_sortTableView removeFromSuperview];
//        [_yinYingView removeFromSuperview];
//    }else{
//        [self.view addSubview:_yinYingView];
//        _sortTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, 375, _sortArr.count*40)];
//        _sortTableView.delegate = self;
//        _sortTableView.dataSource = self;
//        [self.view addSubview:_sortTableView];
//    }
//    _flag3 = !_flag3;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.coodinate = [DPAppDelegate instance].coodinate;
}





-(void)requstDataWithURL:(NSString *)url WithParam:(NSString *)param{
    [[[DPAppDelegate instance] dpapi] requestWithURL:url paramsString:param delegate:self];
    
}

#pragma mark - DPRequestDelegate方法
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
  
    NSArray *businesses = result[@"businesses"];
    NSArray *regions = result[@"cities"];
    NSArray *cateArr = result[@"categories"];
    if (businesses.count){
        for (NSDictionary *dic in businesses) {
            ShangJiaModel *model = [[ShangJiaModel alloc] init];
            
            NSArray *arr = [dic[@"name"] componentsSeparatedByString:@"("];
            model.name = [arr firstObject];
            model.add = dic[@"address"];
            model.telephone = dic[@"telephone"];
            model.regions = [dic[@"regions"] firstObject];
            model.categore = [dic[@"categories"] firstObject];
            model.rating = [NSString stringWithFormat:@"%@",dic[@"avg_rating"]];
            model.retingImg = dic[@"rating_s_img_url"];
            model.photo = dic[@"photo_url"];
            model.bid = dic[@"business_id"];
            [_dataArr addObject:model];
        }
        // [_tableView reloadData];
//        [self requstDataWithURL:STORE_REGIONS WithParam:[NSString stringWithFormat:@"city=%@",[DPAppDelegate instance].city]];
        [_collectionView reloadData];
          [_imageVIew stopAnimating];
    }else if(regions.count){
        NSDictionary *city = [regions firstObject];
        NSArray *region = city[@"districts"];
#warning 根据返回的区域和美食来给下拉表填数据
        for (NSDictionary *dic in region) {
            NSString *str = dic[@"district_name"];
            [_regionArr addObject:str];
        }
       
    }else{
        for (NSDictionary *dic in cateArr) {
            [_cateArr addObject:dic[@"category_name"]];
            NSArray *subCate = dic[@"subcategories"];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic2 in subCate) {
                [tempArr addObject:dic2[@"category_name"]];
            }
            [_subCateArr addObject:tempArr];
        }
    }
}


#pragma mark - DropDownMenu代理方法
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _cateArr.count;
    }else if (column == 1){
        return _regionArr.count-1;
    }else {
        return _sortArr.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _cateArr[indexPath.row];
    } else if (indexPath.column == 1){
        return _regionArr[indexPath.row];
    } else {
        return _sortArr[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        NSArray *arr = _subCateArr[row];
        return arr.count;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        NSArray *arr = _subCateArr[indexPath.row];
        return arr[indexPath.item];
    }
    return nil;
}

//根据用户选择的选项，来决定怎么请求数据
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //如果item大于或者等于零，表示第一项里边的子选项被点击了，这时候调用请求
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSArray *arr = _subCateArr[indexPath.row];
         [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"city=%@&keyword=%@",[DPAppDelegate instance].city,arr[indexPath.item]]];
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    //如果点击的是第三个，就请求排序方式
    if (indexPath.column==2) {
                switch (indexPath.row) {
                    case 0:
                        [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,1]];
                        break;
                       case 1:
                         [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,4]];
                        break;
                        case 2:
                        [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,2]];
                        break;
                    default:
                         [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,7]];
                        break;
                }
    }else if (indexPath.column==1){
    //如果点击的是第二个就是请求区域
        [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"city=%@&region=%@",[DPAppDelegate instance].city,_regionArr[indexPath.row]]];
    }else if (indexPath.column==0){
         [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"city=%@&keyword =%@",[DPAppDelegate instance].city,_cateArr[indexPath.row]]];
    }
}


#pragma mark - 请求数据的代理方法
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载数据失败，请检查网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
    NSLog(@"111加载数据失败，error = %@",error);
}



#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (tableView==_sortTableView) {
//        return _sortArr.count;
//    }else{
        return 0;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        ShangJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ShangJiaModel *model = _dataArr[indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:model.photo]];
        cell.lableName.text = model.name;
        cell.lableAdd.text = model.add;
        //设置评分视图，因为测试数据默认评分都是零，所以自己随机一个评分布局
        //  [cell.imageRating setImageWithURL:[NSURL URLWithString:model.retingImg]];
        NSString *str = [NSString stringWithFormat:@"http://i2.dpfile.com/s/i/app/api/16_%dstar.png",arc4random()%3+3];
        [cell.imageRating setImageWithURL:[NSURL URLWithString:str]];
        cell.lableCate.text = model.categore;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systermCell"];
    if (cell==nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systermCell"];
    }
//    if (tableView==_sortTableView) {
//        cell.textLabel.text = _sortArr[indexPath.row];
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView==tableView) {
        return 91;
    }
    return 40;
}
//如果被选择，做出什么操作？
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView==_sortTableView) {
//        UIButton *btn = (UIButton *)[self.view viewWithTag:33];
//        [btn setTitle:_sortArr[indexPath.row] forState:UIControlStateNormal];
//        [_yinYingView removeFromSuperview];
//        [_sortTableView removeFromSuperview];
//        switch (indexPath.row) {
//            case 1:
//                [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,1]];
//                break;
//               case 2:
//                 [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,4]];
//                break;
//                case 3:
//                [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,2]];
//                break;
//            default:
//                 [self requstDataWithURL:SEARCH_STORE_URL WithParam:[NSString stringWithFormat:@"latitude=%f&longitude=%f&sort=%d",self.coodinate.latitude,self.coodinate.longitude,7]];
//                break;
//        }
//    }
}

#pragma collectionView 代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
//    ShangJiaModel *model = _dataArr[indexPath.row];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:model.photo]];
//    cell.nameLabel.text = model.name;
//    cell.addLable.text = model.add;
//    //设置评分视图，因为测试数据默认评分都是零，所以自己随机一个评分布局
//    //  [cell.imageRating setImageWithURL:[NSURL URLWithString:model.retingImg]];
//    NSString *str = [NSString stringWithFormat:@"http://i2.dpfile.com/s/i/app/api/16_%dstar.png",arc4random()%5];
//    [cell.imageRating setImageWithURL:[NSURL URLWithString:str]];
    
    ShangJiaModel *model = _dataArr[indexPath.row];

    [cell.imageView setImageWithURL:[NSURL URLWithString:model.photo]];
    cell.nameLabel.text = model.name;
    cell.addLable.text = model.add;
    //设置评分视图，因为测试数据默认评分都是零，所以自己随机一个评分布局
    //  [cell.imageRating setImageWithURL:[NSURL URLWithString:model.retingImg]];
    NSString *str = [NSString stringWithFormat:@"http://i2.dpfile.com/s/i/app/api/16_%dstar.png",arc4random()%5];
    [cell.imageRating setImageWithURL:[NSURL URLWithString:str]];
    NSLog(@"行数：%ld",indexPath.row);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShangJiaModel *model = _dataArr[indexPath.row];
    ShangXQingController *sxl = [[ShangXQingController alloc] init];
    sxl.model = model;
    ShangImageController *imageCL = [[ShangImageController alloc] initWithImageUrl:model.photo];
    OSBlurSlideMenuController *omcl = [[OSBlurSlideMenuController alloc] initWithMenuViewController:sxl andContentViewController:imageCL];
    [self.navigationController pushViewController:omcl animated:YES];
}
@end
