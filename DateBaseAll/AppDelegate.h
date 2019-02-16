//
//  AppDelegate.h
//  DateBaseAll
//
//  Created by Tony on 2018/9/18.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

