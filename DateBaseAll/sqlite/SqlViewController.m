//
//  SqlViewController.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/25.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SqlViewController.h"
#import "DataBaseManager.h"//sqlite数据库的封装
@interface SqlViewController ()
@property(nonatomic,strong)NSMutableArray *dateArr;
@end

@implementation SqlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建表格
    [DataBaseManager createTable];
    _dateArr = [NSMutableArray array];
    //查询所有信息
    NSArray *array = [DataBaseManager selectStudent];
    for (Student *stu in array) {
        [_dateArr addObject:stu];
    }
}
- (IBAction)reBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addDate:(id)sender {
    //创建学生对象
    Student *stu = [[Student alloc]init];
    stu.number = arc4random()%100;
    stu.name = [NSString stringWithFormat:@"小明%u",arc4random()%100];
    stu.gender = [NSString stringWithFormat:@"男%u",arc4random()%100];;
    stu.age = arc4random()%100;
    //将学生对象存入数据库
    [DataBaseManager insertStudent:stu];
    [_dateArr removeAllObjects];
    NSArray *array = [DataBaseManager selectStudent];
    for (Student *stu in array) {
        [_dateArr addObject:stu];
    }
    [self.myTableView reloadData];
}
- (IBAction)selectDate:(id)sender {
    [_dateArr removeAllObjects];
    //查询所有信息
    NSArray *array = [DataBaseManager selectStudent];
    for (Student *stu in array) {
        [_dateArr addObject:stu];
    }
    [self.myTableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@   学号:%ld   性别:%@   年龄:%ld",[_dateArr[indexPath.row] name],(long)[_dateArr[indexPath.row] number],[_dateArr[indexPath.row] gender],(long)[_dateArr[indexPath.row] age]];
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
    __weak SqlViewController *weakSelf = self;
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Student *stu = weakSelf.dateArr[indexPath.row];
        //删除指定学号的学生
        [DataBaseManager deleteStudent:stu.number];
        [weakSelf.dateArr removeObject:stu];
        [self.myTableView reloadData];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //添加一个置顶按钮
    UITableViewRowAction *editeRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //更新指定学号的学生
        Student *stu = weakSelf.dateArr[indexPath.row];
        stu.name = @"小明";
        stu.gender = @"男";
        stu.age = 15;
        [DataBaseManager updateStudent:stu Number:stu.number];
        [weakSelf.dateArr replaceObjectAtIndex:indexPath.row withObject:stu];
        [self.myTableView reloadData];
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
