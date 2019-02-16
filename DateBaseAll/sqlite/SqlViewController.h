//
//  SqlViewController.h
//  DateBaseAll
//
//  Created by Tony on 2018/9/25.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqlViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *AddBtn;
@property (weak, nonatomic) IBOutlet UIButton *SelectBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
