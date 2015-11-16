//
//  WoDeViewController.m
//  MiTuan
//
//  Created by xieyoulei on 15/4/21.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "WoDeViewController.h"

@interface WoDeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation WoDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

-(void)login:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"暂不支持登陆功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
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
