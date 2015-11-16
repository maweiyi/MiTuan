//
//  GengduoViewController.m
//  MiTuan
//
//  Created by xieyoulei on 15/4/21.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "GengduoViewController.h"
#import "ScanViewController.h"

@interface GengduoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *slideButton;
@property (weak, nonatomic) IBOutlet UIView *saoView;
@property (weak, nonatomic) IBOutlet UIButton *saomiaoB;

@end

@implementation GengduoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.slideButton setImage:[UIImage imageNamed:@"ic_global_uikit_switch_off.png"] forState:UIControlStateNormal];
    [self.slideButton setImage:[UIImage imageNamed:@"ic_global_uikit_switch_on.png"] forState:UIControlStateSelected];
    [self.slideButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
   
    self.saoView.userInteractionEnabled = YES;
    [self.saomiaoB addTarget:self action:@selector(saomiao) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)saomiao{
    NSLog(@"aaaaa");
    ScanViewController *svc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)btnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
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
