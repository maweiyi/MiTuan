//
//  HomeScrollView.m
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "HomeScrollView.h"


#define FENLEI_URL @"http://api.mobile.meituan.com/group/v3/cate/menu/android/5.4?city=72&extendHomepage=true&mypos=34.78646%2C113.671381&client=android&hasGroup=false&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC576582575473515520_c1_e3ee3ab167013fd9f942d7c6783242c2dD200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428484632056&userid=111468826"
#define FENLEI_URLL @"http://api.mobile.meituan.com/group/v3/cate/menu/android/5.4?city=73&extendHomepage=true&mypos=34.78668%2C113.67121&client=android&hasGroup=false&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826"
//http://api.mobile.meituan.com/group/v1/itemportal/position/34.786414,113.671225?utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826 餐厅
//http://api.mobile.meituan.com/group/v1/recommend/homepage/city/73?userId=111468826&position=34.786373%2C113.671204&fields=id%2Cslug%2Ccate%2Csubcate%2Cdtype%2Cctype%2Cmlls%2Csolds%2Cstatus%2Crange%2Cstart%2Cend%2Cimgurl%2Csquareimgurl%2Ctitle%2Chotelroomname%2Cprice%2Cvalue%2Cmname%2Cbrandname%2Crating%2Crate-count%2Csatisfaction%2Cmealcount%2Cnobooking%2CattrJson%2ChotelExt%2Ccampaigns%2Cterms%2Crecreason%2Cshowtype%2Cdeposit%2Csecurityinfo%2Coptionalattrs%2Cbookinginfo%2Cpricecalendar%2Cisappointonline%2Ccouponbegintime%2Ccouponendtime%2Crdploc%2Crdcount%2Cdigestion%2CisAvailableToday&client=android&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826  猜你喜欢
//http://api.mobile.meituan.com/group/v1/deal/activity/73?ptId=android_5.4&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826 名店折上折
//http://api.mobile.meituan.com/group/v1/user/111468826/recommend/survey?token=F5FCW3X6g0ENgDXvr6LDqvSJuL0AAAAATAAAABiklkhDPQG-9KVumhSk50_KumSXT3AfLA7yRBHnbP2oHpO7dpLvwXtzZo7_R9K2Kg&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826  搜索框
//http://api.mobile.meituan.com/group/v1/deal/topic/discount/city/73?version_name=5.4&limit=5&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__bGhomepage_search&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826  畅享霸王餐
//http://api.mobile.meituan.com/group/v1/deal/search/hotword/city/73?cateId=-1&mypos=34.78668%2C113.67121&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__bGhomepage_search&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826  郑州 热门搜索
#define WINDOW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation HomeScrollView
{
    NSArray *_lableArr;
    NSArray *_btnArr;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//view高200
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _lableArr = @[@"购物",@"美食",@"休闲娱乐",@"丽人",@"结婚亲子",@"酒店",@"生活服务",@"院线影院",@"旅游",@"全部"];
        _btnArr = @[@"001",@"002",@"003",@"004",@"005",@"006",@"007",@"008",@"009",@"010"];
        
        self.strArr = [[NSMutableArray alloc] init];
        self.imageArr = [[NSMutableArray alloc] init];
        //[self dataLoad];
        //[self performSelector:@selector(creatBackground) withObject:nil afterDelay:10];
        [self creatBackground];
    }
    return self;
}

-(void)creatBackground{

    for (int page=0; page<2; page++) {
        for (int row=0; row<2; row++) {
            for (int conlum=0; conlum<4; conlum++) {
                int num = page*8+row*4+conlum;
                if (num==10) {
                    return;
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //UILabel *lable = [[UILabel alloc] init];
                
                //布置button的frame
                btn.frame = CGRectMake(31+conlum*86+page*WINDOW_WEIGHT, 13.3+row*93.3, 55, 80);
                btn.showsTouchWhenHighlighted = YES;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                //lable.frame = CGRectMake(btn.frame.origin.x-5, btn.frame.origin.y+45, 50, 20);
               // lable.font = [UIFont systemFontOfSize:12];
                //lable.textAlignment = NSTextAlignmentCenter;
//                if (num<_btnArr.count) {
//                    lable.text = _lableArr[num];
//                    UIImage *img = [UIImage imageWithData:_btnArr[num]];
//                    [btn setImage:img forState:UIControlStateNormal];
//                    [self addSubview:lable];
//                    [self addSubview:btn];
//                }
                NSString *path = [[NSBundle mainBundle] pathForResource:_btnArr[num] ofType:@"png"];
                //NSLog(@"%@",path);
                UIImage *image = [UIImage imageWithContentsOfFile:path];
               // NSLog(@"%@",_btnArr[num]);
                [btn setImage:image forState:UIControlStateNormal];
                [self addSubview:btn];
                btn.tag = 30+num;
            }
        }
    }
}

-(void)btnAction:(UIButton *)btn{
    NSLog(@"w bei dian ji le ");
    if (self.block) {
        self.block(_lableArr[btn.tag-30]);
    }
}


-(void)dataLoad{
    DPAppDelegate *dele = [DPAppDelegate instance];
    _context = dele.managedObjectContext;
    //创建数据请求
    NSFetchRequest *requst = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomeModelOne" inManagedObjectContext:_context];
    //设置请求实体
    [requst setEntity:entity];
    
    //设置搜索条件要看仔细，不然会崩！错误：keypath name not found in entity <NSSQLEntity Homebutton01 id=1>
    //指定对结果的排序方式
    // NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lable" ascending:NO];
    //    //设置排序条件
    //[requst setSortDescriptors:@[sort]];
    //搜索谓词
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lable=='Herbie'"];
    //[requst setPredicate:predicate];
    
    
    //执行获取数据请求，返回数组
    NSMutableArray *mutablFetchResult = [[_context executeFetchRequest:requst error:nil] mutableCopy];
    if (mutablFetchResult.count == 0) {
        NSLog(@"加载数据到数据库");
        [self initCoredata];
        [self performSelector:@selector(creatBackground) withObject:nil afterDelay:10];

    }else{
        NSLog(@"%ld",mutablFetchResult.count);
        for (HomeModelOne *model in mutablFetchResult) {
            //NSLog(@"model = %@",model.lableText);
            //[_lableArr addObject:model.lableText];
           // [_btnArr addObject:model.btnImage];
            
            //以下两句用于网络不好时删除数据库数据：
//            [_context deleteObject:model];
//            [_context save:nil];
        }
        [self creatBackground];
    }
}

-(void)initCoredata{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:FENLEI_URLL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        NSArray *home = dic[@"homepage"];
        NSLog(@"home = %@",home);
        for (NSDictionary *dic1 in home) {
            HomeModelOne *model = [NSEntityDescription insertNewObjectForEntityForName:@"HomeModelOne" inManagedObjectContext:_context];
            model.lableText = dic1[@"name"];
            NSString *iconURL = dic1[@"iconUrl"];
           // NSLog(@"%@",model.lableText);
            //把返回格式设置为二进制
            manager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
            
            [manager GET:iconURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                model.btnImage = responseObject;
               // [_lableArr addObject:model.lableText];
               // [_btnArr addObject:model.btnImage];
                [_context save:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




@end
