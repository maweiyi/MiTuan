//
//  CityModel.h
//  MiTuan
//
//  Created by wangZL on 15-4-13.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CityModel : NSManagedObject

@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * weidu;
@property (nonatomic, retain) NSString * jingdu;

@end
