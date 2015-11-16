//
//  ShangXQingController.m
//  MiTuan
//
//  Created by wangZL on 15/4/29.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ShangXQingController.h"

@interface ShangXQingController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ShangXQingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text =self.model.name;
    self.cateLabel.text = [NSString stringWithFormat:@"商家类型:%@",self.model.categore];
    self.addLabel.text = [NSString stringWithFormat:@"地址:%@",self.model.add];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",self.model.telephone];
    // Do any additional setup after loading the view from its nib.

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
