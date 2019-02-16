//
//  FMDBViewController.m
//  DateBaseAll
//
//  Created by Tony on 2018/9/27.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "FMDBViewController.h"
#import "Worker.h"

#import "FMDBManager.h"
@interface FMDBViewController ()
@property(nonatomic,copy)NSMutableArray *dateArr;
@property(nonatomic,strong)FMDatabase *dataBase;

@property(nonatomic,strong)FMDBManager *daManager;
@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateArr = [NSMutableArray array];
    _daManager = [FMDBManager shareDateBase];
    [self selectAction];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addAction:(id)sender {
    Worker *work = [[Worker alloc]init];
    work.number = arc4random_uniform(40);
    work.name =  [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
    work.age = arc4random_uniform(40);
    [[FMDBManager shareDateBase] insertDataWithWorker:work AndTableName:@"t_worker"];
    [self selectLastData];
}

- (IBAction)selectDate:(id)sender {
    [self selectAction];
}
-(void)selectAction
{
    [_dateArr removeAllObjects];
    _dateArr = [NSMutableArray arrayWithArray:[[FMDBManager shareDateBase] getAllDataWithTableName:@"t_worker"]];
    [self.myTableView reloadData];
}
-(void)selectLastData
{
    Worker *work = [[FMDBManager shareDateBase]getLastDataWithTableName:@"t_worker"];
    [_dateArr addObject:work];
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
    Worker *worker = _dateArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"工号:%ld  名字:%@  年龄:%ld",(long)worker.number,worker.name,(long)worker.age];
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
    __weak FMDBViewController *weakSelf = self;
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
        Worker *work = weakSelf.dateArr[indexPath.row];
        [[FMDBManager shareDateBase]deleteDateWithWorker:work AndTableName:@"t_worker"];
        [weakSelf.dateArr removeObject:work];
        [self.myTableView reloadData];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //添加一个置顶按钮
    UITableViewRowAction *editeRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //修改学生的名字
        Worker *work = weakSelf.dateArr[indexPath.row];
        work.newname = @"new name";
        [[FMDBManager shareDateBase]updateDataWithWorker:work AndTableName:@"t_worker"];
        [self selectAction];
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
