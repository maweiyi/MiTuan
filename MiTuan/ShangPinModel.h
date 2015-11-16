//
//  ShangPinModel.h
//  MiTuan
//
//  Created by wangZL on 15-4-15.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShangPinModel : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descri;
@property (nonatomic, retain) NSString * currentPrice;
@property (nonatomic, retain) NSString * purchase_date;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * deal_id;

@end
