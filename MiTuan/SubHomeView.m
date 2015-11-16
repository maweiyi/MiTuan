//
//  SubHomeView.m
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SubHomeView.h"
#import "MingDianModel.h"

#define WINDOW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MINGDIAN_URL @"http://api.mobile.meituan.com/group/v1/deal/activity/73?ptId=android_5.4&utm_source=waputm_pinzhuanbt&utm_medium=android&utm_term=240&version_name=5.4&utm_content=A1000035DEB13A&utm_campaign=AgroupBgroupC0D200E0Fab_a502poi__b__a___ab_gxhceshi__nostrategy__leftflow___ab_gxhceshi0202__a__leftflow___ab_chunceshishuju__b__b___ab_gxh_82__nostrategy__leftflow___ab_pindaochangsha__a__leftflow___ab_pindaoshenyang__b__b&ci=73&uuid=EEE34AAC78EDDC346545BCB6AA8857C797B57B34412A11A186D56293085A9EB7&msid=A1000035DEB13A1428555975967&userid=111468826"
@implementation SubHomeView

{
    NSMutableArray *_dataArr;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//view高140
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _dataArr = [[NSMutableArray alloc] init];
        UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
        backView.image = [UIImage imageNamed:@"mingdian2.jpg"];
        [self addSubview:backView];
        [self dataLoad];
        //lable的设置
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 83, 27)];
        imageView.image = [UIImage imageNamed:@"mingdian.png"];
        [self addSubview:imageView];
        
        lable.text = @"名店抢购";
        lable.font = [UIFont systemFontOfSize:14];
       // [self addSubview:lable];
        
        
//        NSInteger count = _dataArr.count;
//        for (int i=0; i<count; i++) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WINDOW_WEIGHT/count+5, 45, WINDOW_WEIGHT/count-10, 45)];
//#warning 布局未完成
//            
//        }
        
    }
    return self;
}
//加载数据
-(void)dataLoad{
    DPAppDelegate *dele = [DPAppDelegate instance];
    _context = dele.managedObjectContext;
    //创建数据请求
    NSFetchRequest *requst = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MingDianModel" inManagedObjectContext:_context];
    //设置请求实体
    [requst setEntity:entity];
    
    
    
    //执行获取数据请求，返回数组
    NSMutableArray *mutablFetchResult = [[_context executeFetchRequest:requst error:nil] mutableCopy];
    if (mutablFetchResult.count == 0) {
        NSLog(@"加载数据到数据库");
        [self initCoredata];
        [self performSelector:@selector(creatBackground) withObject:nil afterDelay:10];
    }else{
       // NSLog(@"%ld",mutablFetchResult.count);

        for (MingDianModel *model  in mutablFetchResult) {
            [_dataArr addObject:model];
        }
        [self creatBackground];
    }
}


-(void)creatBackground{
            NSInteger count = _dataArr.count;
            NSArray *arr =@[@"傣妹火锅",@"煌上煌酒店",@"香天下"];
            for (int i=0; i<count; i++) {
                //view的初始化
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*WINDOW_WEIGHT/count+5, 45, WINDOW_WEIGHT/count-10, 45)];
                [self addSubview:imageView];
                
                UILabel *lableName = [[UILabel alloc] initWithFrame:CGRectMake(i*WINDOW_WEIGHT/count+5, 95, WINDOW_WEIGHT/count-10, 30)];
                lableName.textAlignment = NSTextAlignmentCenter;
                lableName.font = [UIFont systemFontOfSize:12];
                lableName.textColor = [UIColor blackColor];
                lableName.tintColor = [UIColor redColor];
                [self addSubview:lableName];
                
                UILabel *lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(i*WINDOW_WEIGHT/count+5, 115, WINDOW_WEIGHT/count-10, 20)];
                lablePrice.textAlignment = NSTextAlignmentCenter;
                lablePrice.font = [UIFont systemFontOfSize:16];
                lablePrice.textColor = [UIColor colorWithRed:150/255.0 green:70/255.0 blue:80/255.0 alpha:1.0];
                [self addSubview:lablePrice];
                
                //利用model里的数据给视图赋值
                MingDianModel *model = _dataArr[i];
                lableName.text = model.name;
                //NSLog(@"name = %@",model.name);
                lablePrice.text = [NSString stringWithFormat:@"￥%@",model.price];
                
                
                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"jpg"];
                    UIImage *image = [UIImage imageWithContentsOfFile:path];
                    imageView.image = image;
                lableName.text = arr[i];
            }
}

-(void)initCoredata{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:MINGDIAN_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析json数据
        NSDictionary *data = responseObject[@"data"];
        NSArray *deals = data[@"deals"];
       // NSLog(@"%@",deals);
        for (NSDictionary *dic in deals) {
            //将解析出来的数据 存入数据库中!
            MingDianModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MingDianModel" inManagedObjectContext:_context];
            model.name = [NSString stringWithFormat:@"%@",dic[@"cateDesc"]];
            
            model.price = [NSString stringWithFormat:@"%@",dic[@"campaignprice"]];
            //设置响应格式为二进制
            manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
            
            [manager GET:dic[@"mdcLogoUrl"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                model.image = responseObject;
                [_dataArr addObject:model];
                [_context save:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}





@end
