//
//  CoreDateManager.h
//  DateBaseAll
//
//  Created by Tony on 2018/9/25.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDateManager : NSObject
//数据模型管理类
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//数据库连接类
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//数据库操作方法(增,删,改,查)
- (void)saveContext;
//数据库本地路径(沙盒路径)
- (NSURL *)applicationDocumentsDirectory;

//获取manager对象的单例方法
+(CoreDateManager *)shareManager;
@end
