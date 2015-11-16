//
//  SerchViewController.m
//  MiTuan
//
//  Created by wangZL on 15/4/30.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SerchViewController.h"
#import "DKTagCloudView.h"
#import "SearchResultController.h"

@interface SerchViewController ()<UITextFieldDelegate>
{
    UITextField *textFiled;
}
@property(nonatomic,weak)DKTagCloudView *tagCloudView;

@end

@implementation SerchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    // Do any additional setup after loading the view.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    DKTagCloudView *tagCloudView = [[DKTagCloudView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width,self.view.bounds.size.height - 264)];
    [self.view addSubview:tagCloudView];
    self.tagCloudView = tagCloudView;
    
    self.tagCloudView.maxFontSize = 20;
    self.tagCloudView.titls = @[
                                @"郭大侠火锅",
                                @"小肥羊",
                                @"德克士",
                                @"大盘鸡",
                                @"华莱士",
                                @"煲仔饭",
                                @"宝视达眼镜",
                                @"比高影院",
                                @"横店电影城",
                                @"大脸鸡排",
                                @"巴奴火锅",
                                @"世纪星酒店",
                                @"自助餐",
                                @"王婆大虾",
                                @"佳客来",
                                @"歌迷KTV",
                                ];
    [self.tagCloudView setTagClickBlock:^(NSString *title, NSInteger index) {
        NSLog(@"title:%@,index:%zd",title,index);
        SearchResultController *resultCtl = [[SearchResultController alloc] init];
        resultCtl.keyword = title;
        [self.navigationController pushViewController:resultCtl animated:YES];
    }];
    [self.tagCloudView generate];
}

-(void)creatUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 375, 40)];
    backView.backgroundColor = [UIColor colorWithRed:25/255.0 green:182/255.0 blue:158/255.0 alpha:1.0];
    [self.view addSubview:backView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 6, 230, 26)];
    [backView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    textFiled = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, 200, 26)];
    textFiled.placeholder = @"输入商家、分类或商圈";
    textFiled.delegate = self;
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [view addSubview:textFiled];
    
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 22, 22)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"search_green" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [searchBtn setImage:image forState:UIControlStateNormal];
    [view addSubview:searchBtn];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 6, 30, 30);
    [backView addSubview:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchBtn1 setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn1.frame = CGRectMake(300, 0, 55, 40);
    [backView addSubview:searchBtn1];
    [searchBtn1 addTarget:self action:@selector(serch) forControlEvents:UIControlEventTouchUpInside];
}
//进行搜索
-(void)serch{
    SearchResultController *resultCtl = [[SearchResultController alloc] init];
    resultCtl.keyword = textFiled.text;
    [self.navigationController pushViewController:resultCtl animated:YES];
}
//返回主界面
-(void)backAction:(UIButton *)tb{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
