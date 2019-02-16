//
//  Teacher+CoreDataProperties.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/18.
//  Copyright © 2018年 Tony. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic number;
@dynamic sex;

@end
