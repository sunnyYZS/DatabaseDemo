//
//  FMDBManager.h
//  DateBaseAll
//
//  Created by Tony on 2018/9/27.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Worker.h"
@interface FMDBManager : NSObject
@property (nonatomic, strong) FMDatabaseQueue *baseQueue;
@property (nonatomic, copy) NSString *dbFilePath;   //数据库路径
@property (nonatomic, copy) NSString *dbTableName;   //数据库文件名
+(FMDBManager *)shareDateBase;

//增
-(void)insertDataWithWorker:(Worker *)worker AndTableName:(NSString *)tableName;
//删
-(void)deleteDateWithWorker:(Worker *)worker AndTableName:(NSString *)tableName;
//查询所有
- (NSArray *)getAllDataWithTableName:(NSString *)tableName;
//查询最后一条
- (Worker *)getLastDataWithTableName:(NSString *)tableName;
//修改
-(void)updateDataWithWorker:(Worker *)worker AndTableName:(NSString *)tableName;
@end
