//
//  ShangImageController.m
//  MiTuan
//
//  Created by wangZL on 15/5/6.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ShangImageController.h"
#import "UIImageView+AFNetworking.h"
@interface ShangImageController ()

@end

@implementation ShangImageController
- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 375, 667-69-49)];
        UIImage *image = [UIImage imageNamed:@"yekongBack"];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
        [self.view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view.
    //设置返回button
   
}
-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
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
