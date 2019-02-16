//
//  DataBaseManager.h
//  Lesson_19(数据库)
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
//第一步:导入系统数据库框架
#import <sqlite3.h>
@interface DataBaseManager : NSObject
+(void)openDataBase;//打开数据库
+(void)closeDataBase;//关闭数据库
+(void)createTable;//创建表格
+(void)insertStudent:(Student *)student;//插入学生信息
+(void)deleteStudent:(NSInteger)number;//根据学号删除学生信息
+(void)updateStudent:(Student *)student Number:(NSInteger)number;
+(NSMutableArray *)selectStudent;
@end
