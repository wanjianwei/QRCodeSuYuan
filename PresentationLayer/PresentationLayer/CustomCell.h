//
//  CustomCell.h
//  PresentationLayer
//
//  Created by jway on 14-11-5.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portrait;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *username;//用户名
@property (weak, nonatomic) IBOutlet UILabel *level; //用户等级
@property (weak, nonatomic) IBOutlet UIButton *dianzhan;//点赞按钮
@property (weak, nonatomic) IBOutlet UILabel *comment; //用户评论
@property (weak, nonatomic) IBOutlet UILabel *time;  //评论时间
@property (weak, nonatomic) IBOutlet UILabel *count;  //点赞人数

//用来存放发送字符串，也就是评论id
@property(nonatomic,strong)NSString*send;


//实现点赞
- (IBAction)click:(id)sender;

@end
