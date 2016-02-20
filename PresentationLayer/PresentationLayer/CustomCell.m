//
//  CustomCell.m
//  PresentationLayer
//
//  Created by jway on 14-11-5.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "CustomCell.h"
#import "BusinessLogicLayer.h"
#import "CommentViewController.h"
@implementation CustomCell
//业务逻辑层
BusinessLogicLayer*layer;
//定义一个flag。用来判断是否只是成功点赞一次
//int flag=0;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)click:(id)sender
{
   
    layer=[BusinessLogicLayer shareManaged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianzhan:) name:@"return_dataNotification" object:nil];
    [layer customer_dianzhan:self.send];

    
}

//响应通知方法
-(void)dianzhan:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    //将单元格索引与返回字符串放在字典类型数据中
    NSNumber*index=[NSNumber numberWithInt:self.dianzhan.tag];
    NSDictionary*dic1=[NSDictionary dictionaryWithObjectsAndKeys:index,@"index",return_string,@"return",nil];
    //将flag变为整型数据
    int flag1=[flag intValue];
    //判断flag状态
    if (flag1==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dianzhanFail" object:self userInfo:dic1];
    }
    else if (flag1==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dianzhanSuccess" object:self userInfo:dic1];
        [self.dianzhan setImage:[UIImage imageNamed:@"dianzan_bt.png"] forState:UIControlStateNormal];
                
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

@end
