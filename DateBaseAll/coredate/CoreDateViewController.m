//
//  CoreDateViewController.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/25.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "CoreDateViewController.h"
#import "CoreDateManager.h"
#import "Teacher+CoreDataClass.h"
@interface CoreDateViewController ()
@property(nonatomic,strong)CoreDateManager *manager;
@property(nonatomic,copy)NSArray *dateArr;
@property(nonatomic,copy)NSMutableArray *mudateArr;
@end

@implementation CoreDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _mudateArr = [NSMutableArray array];
    _manager = [CoreDateManager shareManager];
    NSLog(@"%@", [_manager applicationDocumentsDirectory]);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"老蒋"];//查询谓词 NSPredicate
    //   [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    //开始查询
    _dateArr = [_manager.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _mudateArr = [NSMutableArray arrayWithArray:_dateArr];
    [self.myTableView reloadData];
}
- (IBAction)reback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addDate:(id)sender {
    //插入语句
        //2.根据表Teacher中的键值，给NSManagedObject对象赋值
        Teacher * teacherObject = [NSEntityDescription  insertNewObjectForEntityForName:@"Teacher"  inManagedObjectContext:_manager.managedObjectContext];
        teacherObject.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
        teacherObject.age = arc4random()%20;
        teacherObject.sex = arc4random()%2 == 0 ?  @"美女" : @"帅哥" ;
        teacherObject.height = arc4random()%180;
        teacherObject.number = arc4random()%100;
        [_manager saveContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"老蒋"];//查询谓词 NSPredicate
    //   [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    //开始查询
    _dateArr = [_manager.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _mudateArr = [NSMutableArray arrayWithArray:_dateArr];
    [self.myTableView reloadData];
}

- (IBAction)selectDate:(id)sender {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"老蒋"];//查询谓词 NSPredicate
    //   [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    //开始查询
    _dateArr = [_manager.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _mudateArr = [NSMutableArray arrayWithArray:_dateArr];
    [self.myTableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mudateArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    Teacher *teach = _mudateArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@   工号:%ld   身高:%ld   年龄:%ld %@",teach.name,(long)teach.number,(long)teach.height,(long)teach.age,teach.sex];
    return cell;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak CoreDateViewController *weakSelf = self;
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //删除语句
        Teacher *teach = weakSelf.mudateArr[indexPath.row];
        [weakSelf.manager.managedObjectContext deleteObject:teach];
        [weakSelf.mudateArr removeObject:teach];
        //没有任何条件就是读取所有的数据
        [weakSelf.manager saveContext];
        [weakSelf.myTableView reloadData];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //添加一个置顶按钮
    UITableViewRowAction *editeRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //修改
        Teacher *teach = weakSelf.mudateArr[indexPath.row];
        teach.name = @"且行且珍惜";
        [weakSelf.manager saveContext];
        [weakSelf.myTableView reloadData];
    }];
    //置顶按钮颜色
    editeRowAction.backgroundColor = [UIColor orangeColor];
    //将设置好的按钮方到数组中返回
    return @[deleteAction,editeRowAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
