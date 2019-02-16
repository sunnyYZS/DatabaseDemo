//
//  ViewController.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/18.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "ViewController.h"

#import "SqlViewController.h"
#import "CoreDateViewController.h"
#import "FMDBViewController.h"
@interface ViewController ()
@property(nonatomic,strong)NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据库总结
    //一：sqlite数据库:原生轻量级数据库 添加liblibsqlite3.0依赖 引入sqlite3.h头文件
    UIButton *button1 =[UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake((self.view.frame.size.width - 175)/2, 50, 175, 50);
    button1.layer.borderWidth = 2.0;
    button1.layer.cornerRadius = 5.0;
    [button1 setTitle:@"sqlite" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(sqliteClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    //二：对sqlite进行了封装 减少代码量 可视化,不用再写SQL语句,大量简化代码 CoreData的代码运行效率没直接使用sql代码的运行效率高
    //参考链接 https://www.jianshu.com/p/332cba029b95
    UIButton *button2 =[UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(button1.frame.origin.x, button1.frame.origin.y + button1.frame.size.height + 10, 175, 50);
    button2.layer.borderWidth = 2.0;
    button2.layer.cornerRadius = 5.0;
    [button2 setTitle:@"coredate" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(coredateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 =[UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(button1.frame.origin.x, button2.frame.origin.y + button2.frame.size.height + 10, 175, 50);
    button3.layer.borderWidth = 2.0;
    button3.layer.cornerRadius = 5.0;
    [button3 setTitle:@"FMDB" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(FMDBAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

-(void)sqliteClickAction
{
    SqlViewController *sql = [[SqlViewController alloc]init];
    [self presentViewController:sql animated:YES completion:nil];
}

-(void)coredateAction
{
    CoreDateViewController *cvc = [[CoreDateViewController alloc]init];
    [self presentViewController:cvc animated:YES completion:nil];
    
}

-(void)FMDBAction
{
    FMDBViewController *fvc = [[FMDBViewController alloc]init];
    [self presentViewController:fvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
