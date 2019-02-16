//
//  FMDBManager.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/27.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "FMDBManager.h"

typedef enum : NSUInteger {
    SQLStringTypeCreate,            //创建
    SQLStringTypeInsert,            //插入
    SQLStringTypeUpdate,            //更新
    SQLStringTypeDelete,            //删除
    SQLStringTypeGetTheLastData,    //获取最后一条
    SQLStringTypeGetAllData,        //获取全部
} SQLStringType;
//自增字段
#define AUTOINCREMENT_FIELD @"chatID"
@interface FMDBManager()

@end

@implementation FMDBManager
static FMDBManager *manager;
//获取Manager对象的单例
+(FMDBManager *)shareDateBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc]init];
    });
    return manager;
}
-(void)insertDataWithWorker:(Worker *)worker AndTableName:(NSString *)tableName
{
//    //1.获得数据库文件的路径
//    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"worker.sqlite"];
//    //2.获得数据库
//    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
//    //3.打开数据库
//    if ([db open]) {
//        //4.创表
//        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_worker (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
//        if (result) {
//            NSLog(@"创表成功");
//        }else
//        {
//            NSLog(@"创表失败");
//        }
//    }
    [self getFilePathWithTableName:tableName];
    __weak FMDBManager *weakself = self;
    [self.baseQueue inDatabase:^(FMDatabase *db) {
        if ([db open])
        {
            //为数据库设置缓存，提高查询效率
            [db setShouldCacheStatements:YES];
            if(![db tableExists:tableName]) {//表不存在
                if(![db tableExists:weakself.dbTableName]) {
                   
                    if ([db executeUpdate:[self concatenateSQLStringWithType:SQLStringTypeCreate withWorker:worker withDataCount:0]]) {
                        if ([db executeUpdate:[self concatenateSQLStringWithType:SQLStringTypeInsert withWorker:worker withDataCount:0]]) {
                            NSLog(@"表创建成功 数据插入成功");
                        } else {
                            NSLog(@"数据插入失败");
                        }
                    }
                }

            } else { //表已存在
                if ([db executeUpdate:[self concatenateSQLStringWithType:SQLStringTypeInsert withWorker:worker withDataCount:0]]) {
                    NSLog(@"数据插入成功");
                } else {
                    NSLog(@"数据插入失败");
                }
            }
        }
        [db close];

    }];
}
- (NSArray *)getAllDataWithTableName:(NSString *)tableName
{
    [self getFilePathWithTableName:tableName];
    __weak FMDBManager *weakself = self;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [self.baseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if(![db tableExists:weakself.dbTableName]) {
                NSLog(@"表格不存在");
                return;
            }
            FMResultSet *resultSet = [db executeQuery:[self concatenateSQLStringWithType:SQLStringTypeGetAllData withWorker:nil withDataCount:0]];
            
            while ([resultSet next]) {
                int ID = [resultSet intForColumn:@"id"];
                NSString *name = [resultSet stringForColumn:@"name"];
                int age = [resultSet intForColumn:@"age"];
                NSLog(@"%d %@ %d", ID, name, age);
                Worker *worker = [[Worker alloc]init];
                worker.number = ID;
                worker.name = name;
                worker.age = age;
                [result addObject:worker];
            }
        }
        [db close];
    }];
    return [result copy];
}
- (Worker *)getLastDataWithTableName:(NSString *)tableName
{
    [self getFilePathWithTableName:tableName];
    Worker *worker = [[Worker alloc]init];
    [self.baseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            if(![db tableExists:tableName]) {
                NSLog(@"表格不存在");
                return;
            }
            FMResultSet *resultSet = [db executeQuery:[self concatenateSQLStringWithType:SQLStringTypeGetTheLastData withWorker:worker withDataCount:0]];
            while ([resultSet next]) {
                int ID = [resultSet intForColumn:@"id"];
                NSString *name = [resultSet stringForColumn:@"name"];
                int age = [resultSet intForColumn:@"age"];
                worker.number = ID;
                worker.name = name;
                worker.age = age;
            }
        }
        [db close];
    }];
    return worker;
}
-(void)deleteDateWithWorker:(Worker *)worker AndTableName:(NSString *)tableName
{
    [self getFilePathWithTableName:tableName];
    __weak FMDBManager *weakself = self;
    [self.baseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if(![db tableExists:weakself.dbTableName]) {
                NSLog(@"表格不存在");
                return;
            }
            if ([db executeUpdate:[self concatenateSQLStringWithType:SQLStringTypeDelete withWorker:worker withDataCount:0]]) {
                NSLog(@"数据删除成功");
            } else {
                NSLog(@"数据删除失败");
            }
           
        }
        [db close];
    }];
}
-(void)updateDataWithWorker:(Worker *)worker AndTableName:(NSString *)tableName
{
    [self getFilePathWithTableName:tableName];
    __weak FMDBManager *weakself = self;
    [self.baseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            if(![db tableExists:weakself.dbTableName]) {
                NSLog(@"表格不存在");
                return;
            }
            if ([db executeUpdate:[self concatenateSQLStringWithType:SQLStringTypeUpdate withWorker:worker withDataCount:0]]) {
                NSLog(@"数据修改成功");
            } else {
                NSLog(@"数据修改失败");
            }
            
        }
        [db close];
    }];
}
//拼接SQL语句方法
- (NSString *)concatenateSQLStringWithType:(SQLStringType)type withWorker:(Worker *)worker withDataCount:(NSUInteger)count
{
    NSString *statementString = @"";
    switch (type) {
        case SQLStringTypeCreate: {
            statementString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL)",_dbTableName];
        }
            break;
        case SQLStringTypeInsert: {
            statementString = [NSString stringWithFormat:@"INSERT INTO %@ (name, age) VALUES ('%@','%ld')",_dbTableName,worker.name,(long)worker.age];
            break;
        }
        case SQLStringTypeDelete: {
            statementString = [NSString stringWithFormat:@"delete from %@ where id = %ld",_dbTableName,(long)worker.number];
        }
            break;
        case SQLStringTypeUpdate: {
            statementString = [NSString stringWithFormat:@"update %@ set name = '%@' where name = '%@'",_dbTableName,worker.newname,worker.name];
        }
            break;
        case SQLStringTypeGetTheLastData: {
            statementString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 1",_dbTableName];
        }
            break;
        case SQLStringTypeGetAllData: {
            statementString = [NSString stringWithFormat:@"SELECT * FROM %@",_dbTableName];
        }
            break;
            
        default:
            break;
    }
    
    return statementString;
}
//获取文件路径
- (void)getFilePathWithTableName:(NSString *)tableName
{
        _dbTableName = tableName;
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _dbFilePath=[doc stringByAppendingPathComponent:@"worker.sqlite"];
}
- (FMDatabaseQueue *)baseQueue
{
    if (!_baseQueue) {
        _baseQueue = [FMDatabaseQueue databaseQueueWithPath:_dbFilePath];
    }
    return _baseQueue;
}

@end
