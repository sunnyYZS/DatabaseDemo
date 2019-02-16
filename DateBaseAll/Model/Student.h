//
//  Student.h
//  Lesson_19(数据库)
//
//  Created by dllo on 15/9/17.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,assign)NSInteger age;
@end
