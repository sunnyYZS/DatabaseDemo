//
//  DataBaseManager.m
//  Lesson_19(数据库)
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "DataBaseManager.h"
//创建数据库对象,静态类型,初始化一次

static sqlite3 *dbPoint = nil;

@implementation DataBaseManager


+ (void)openDataBase
{
    if (dbPoint) {
        return;
    }else
    {
        //数据库对象还没有,我们应该去创建数据库文件
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        
        path = [path stringByAppendingPathComponent:@"MyDataBase.sqlite"];
        
        //执行sqlite的打开数据库函数
        sqlite3_open(path.UTF8String, &dbPoint);
        
        NSLog(@"%@", path);
    }
}

+ (void)closeDataBase
{
    //关闭数据库
    int result = sqlite3_close(dbPoint);
    if (result == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
        dbPoint = nil;
    }else {
        NSLog(@"关闭数据库失败");
    }
}


#if 1
+ (void)createTable
{
    //第一步:打开数据库
    [self openDataBase];
    
    //编写SQL语句
    NSString *sqlString = @"CREATE TABLE IF NOT EXISTS lanou0710(number INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100), gender varchar(5), age INTEGER)";
    
    //执行sql语句
    int result = sqlite3_exec(dbPoint, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"表格创建成功");
    }else
    {
        NSLog(@"表格创建失败%d", result);
    }
    
    //关闭数据库
    [self closeDataBase];
    
}

#endif

+ (void)insertStudent:(Student *)student
{
    //打开数据库
    [self openDataBase];
    
    //编写sql语句
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO lanou0710(name, gender, age) VALUES ('%@', '%@', '%ld')",student.name, student.gender, student.age];
    
    //执行sql语句
    int result = sqlite3_exec(dbPoint, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    }else
    {
        NSLog(@"插入失败%d", result);
    }
    
    [self closeDataBase];
    
}

+(void)deleteStudent:(NSInteger)number
{
    //打开数据库
    [self openDataBase];
    //编写SQL语句
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM lanou0710 WHERE number = '%ld'",number];
    //执行SQL语句
    int result = sqlite3_exec(dbPoint, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"删除失败 %d", result);
    }
    
    [self closeDataBase];
}

+(void)updateStudent:(Student *)student Number:(NSInteger)number
{
    //打开数据库
    [self openDataBase];
    //编写SQL语句
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE lanou0710 SET name = '%@', gender = '%@', age = '%ld' WHERE number = '%ld'",student.name,student.gender,student.age,number];
    //执行
    int result = sqlite3_exec(dbPoint, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"更新成功");
    }
    else
    {
        NSLog(@"更新失败 %d", result);
    }
    //关闭数据库
    [self closeDataBase];
}

+(NSMutableArray *)selectStudent
{
    //打开数据库
    [self openDataBase];
    //创建数据库替身
    sqlite3_stmt *stmt = nil;
    //准备SQL语句
    NSString *sqlString = @"SELECT * FROM lanou0710";
    //执行SQL语句
    int result = sqlite3_prepare_v2(dbPoint, sqlString.UTF8String, -1, &stmt, nil);
    //创建一个数组,来存放查询后的对象
    NSMutableArray *array = [NSMutableArray array];
    //判断result
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        //遍历符合条件的每一行
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //如果下一行有数据,就去读取
            int number = sqlite3_column_int(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *gender = sqlite3_column_text(stmt, 2);
            int age = sqlite3_column_int(stmt, 3);
            //对读取出来的信息进行转义
            NSInteger num = number;
            NSString *stuName = [NSString stringWithUTF8String:(const char *)name];
            NSString *stuGender = [NSString stringWithUTF8String:(const char *)gender];
            NSInteger stuAge = age;
            //将四条数据封装成一个学生对象
            Student *student = [[Student alloc]init];
            student.number = num;
            student.name = stuName;
            student.gender = stuGender;
            student.age = stuAge;
            [array addObject:student];
        }
    }
    else
    {
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    [self closeDataBase];
    //返回数组
    return  array;
}


@end
