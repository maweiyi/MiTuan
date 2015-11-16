//
//  AppDelegate.h
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DPAPI.h"
#import <MapKit/MapKit.h>

@interface DPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//数据库相关
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//请求接口相关
@property (readonly, nonatomic) DPAPI *dpapi;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;
//存储地图所点击点的经纬度
@property(assign,nonatomic)CLLocationCoordinate2D coodinate;
//存取当前城市
@property(copy,nonatomic)NSString *city;

+ (DPAppDelegate *)instance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

