//
//  CommentViewController.m
//  PresentationLayer
//
//  Created by jway on 14-11-4.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "CommentViewController.h"
#import "CustomCell.h"
#import "BusinessLogicLayer.h"
#import "LeafNotification.h"
@interface CommentViewController ()
@end


@implementation CommentViewController
//定义业务逻辑层
BusinessLogicLayer*layer;
//定义向服务器请求评论的次数（每次显示10条）
int n=1;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.comment_list.dataSource=self;
    self.comment_list.delegate=self;
    //初始化业务逻辑层
    layer=[BusinessLogicLayer shareManaged];
    //注册接受点赞成功与失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:@"dianzhanSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fail:) name:@"dianzhanFail" object:nil];
    
    //注册一个手势处理器，为的是点击视图背景，关闭键盘,并未设置其接受多点触碰，所以默认只接受单击
    UIGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
    //修饰下评论按钮的外观
    self.comment_pty.layer.cornerRadius=4.0f;
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    //释放对象
    self.Allcomment=nil;
    self.comment_list=nil;
    self.comment_input=nil;
    [super viewDidDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
    
}

-(void)success:(NSNotification*)notification
{
    NSDictionary*dic=[notification userInfo];
    int index_temp=(int)[[dic objectForKey:@"index"] integerValue];
   // NSArray*array=[self.Allcomment componentsSeparatedByString:@"#"];
    //点赞之前的点赞人数
    NSString*count=[self.Allcomment objectAtIndex:6*index_temp+5];
    int count_temp=[count intValue];
    int count_temp2=count_temp+1;
    NSMutableArray*array1=[self.Allcomment mutableCopy];
    [array1 replaceObjectAtIndex:6*index_temp+5 withObject:[NSString stringWithFormat:@"%i",count_temp2]];
    self.Allcomment=[array1 copy];
    [self.comment_list reloadData];
    //释放对象，节约内存
    array1=nil;
}

-(void)fail:(NSNotification*)notification
{
    [LeafNotification showInController:self withText:[[notification userInfo] objectForKey:@"return"]];
}

-(void)keyboardHide
{
    [self.comment_input resignFirstResponder];
}

- (IBAction)comment:(id)sender
{
    [self.comment_input resignFirstResponder];
    if ([self.comment_input.text isEqualToString:@""])
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"评论内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if (layer.socket1.isConnected==NO)
        {
             [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:8808];
        }
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_comments:) name:@"return_dataNotification" object:nil];
        [layer customer_comment:[NSString stringWithFormat:@"%@#%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tagID"],self.comment_input.text]];
        //设置评论按钮的属性
        self.comment_pty.alpha=0.5;
        self.comment_pty.userInteractionEnabled=NO;
    }
}

//返回操作
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    n=1;
}


//响应通知方法
-(void)return_comments:(NSNotification*)notification
{
   
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    //如果出错
    if (flag1==2)
    {
        [LeafNotification showInController:self withText:@"发表评论失败"];
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
    }
    else if(flag1==1)
    {
        //移除return_data通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
        //重新调用方法返回所有评论
        [self performSelector:@selector(getcomments) withObject:nil afterDelay:1.0f];
    }
    
}

//此处向服务器请求的n值设为0，表示只是请求前10条评论，这样正好可以显示用户自己的评论
-(void)getcomments
{
    //注册接受通知，该通知与return_data名字不同，为的是与其区分开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_Allcomments:) name:@"return_passwordNotification" object:nil];
    [layer customer_checkcomments:[NSString stringWithFormat:@"%@#0",[[NSUserDefaults standardUserDefaults] objectForKey:@"tagID"]]];
}
//响应return_passwordNotification
-(void)return_Allcomments:(NSNotification*)notification
{
    //恢复评论按钮的属性
    self.comment_pty.alpha=1.0;
    self.comment_pty.userInteractionEnabled=YES;
    
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==2)
    {
        [LeafNotification showInController:self withText:@"发表评论失败"];
    }
    else if(flag1==1)
    {
        self.comment_input.text=nil;
        //将服务器返回数据加入Allcomment中,服务器返回的是前10条评论
       self.Allcomment=[return_string componentsSeparatedByString:@"#"];
        //重新加载表示图
        [self.comment_list reloadData];
        [LeafNotification showInController:self withText:@"发表评论成功" type:LeafNotificationTypeSuccess];
    }
    //再次将n设置为1
     n=1;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_passwordNotification" object:nil];

}

//表视图协议方法,返回节数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果评论数小于10条，那么就不需要另加“加载更多”单元格
    if ((self.Allcomment.count-1)/6<10)
        return (self.Allcomment.count-1)/6;
   else
        return (self.Allcomment.count-1)/6+1;
}

//设置单元格
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==(self.Allcomment.count-1)/6)
    {
        UITableViewCell*cell=[[UITableViewCell alloc] initWithFrame:CGRectZero];
        UIButton*bt=[[UIButton alloc] initWithFrame:CGRectMake(130, 25, 120, 35)];
        [bt addTarget:self action:@selector(getMore:) forControlEvents:UIControlEventTouchUpInside];
        //定义按按钮的外观
        bt.layer.borderColor=[[UIColor blackColor] CGColor];
        bt.layer.cornerRadius=4.0f;
        bt.layer.borderWidth=2.0f;
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitle:@"加载更多" forState:UIControlStateNormal];
        [cell addSubview:bt];
        return cell;
    }
    else
    {
    static NSString*CellIdentifier=@"Cell";
    CustomCell*cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //设置自定义单元格各个控件的显示内容
    cell.portrait.image=[UIImage imageNamed:@"portrait.png"];
    NSUInteger row=[indexPath row];
    cell.dianzhan.tag=row;
    //取出每条评论的tagid，执行点赞操作时作为发送字符串
    cell.send=[self.Allcomment objectAtIndex:6*row];
    cell.username.text=[self.Allcomment objectAtIndex:(6*row+1)];
    cell.level.text=[NSString stringWithFormat:@"用户等级:%@",[self.Allcomment objectAtIndex:(6*row+2)]];
    cell.comment.text=[self.Allcomment objectAtIndex:(6*row+4)];
    //时间
    cell.time.text=[self.Allcomment objectAtIndex:(6*row+3)];
    //点赞数
    cell.count.text=[self.Allcomment objectAtIndex:(6*row+5)];
    return cell;
    }
    
}

-(void)getMore:(id)sender
{
    UIButton*bt=(UIButton*)sender;
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt setTitle:@"加载中" forState:UIControlStateNormal];
    NSString*send=[NSString stringWithFormat:@"%@#%i",[[NSUserDefaults standardUserDefaults] objectForKey:@"tagID"],n];
    //注册接受通知，该通知与return_data名字不同，为的是与其区分开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_othercomments:) name:@"return_passwordNotification" object:nil];
    [layer customer_checkcomments:send];}

/*

//点击加载单元格,再次向服务器请求10条评论
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"已执行");
    if (indexPath.row==(self.Allcomment.count-1)/6)
    {
        NSString*send=[NSString stringWithFormat:@"%@#%i",[[NSUserDefaults standardUserDefaults] objectForKey:@"tagID"],n];
        //改变加载框的文本说明
        UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text=@"           加载中......";
        cell.textLabel.font=[UIFont boldSystemFontOfSize:13];
        //注册接受通知，该通知与return_data名字不同，为的是与其区分开
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_othercomments:) name:@"return_passwordNotification" object:nil];
        NSLog(@"zhixinle");
        [layer customer_checkcomments:send];
    }
}
*/
//响应通知方法，点击加载更多后的响应方法
-(void)return_othercomments:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==2)
    {
        [LeafNotification showInController:self withText:@"评论请求失败"];
        [self.comment_list reloadData];
    }
    else if(flag1==1)
    {
        //如果返回的字符串不为空，则将服务器返回数据加入Allcomment中,添加在尾部
        if (![return_string isEqual:nil])
        {
        NSMutableArray*array1=[self.Allcomment mutableCopy];
        //把最后一个空元素去掉
        [array1 removeLastObject];
        NSArray*array2=[return_string componentsSeparatedByString:@"#"];
        //将新请求到得10条评论加到原评论尾部
        [array1 addObjectsFromArray:array2];
        self.Allcomment=[array1 copy];
        //将n的值加1，下次请求另外10条评论
        n=n+1;
        }
        //重新加载表示图
        [self.comment_list reloadData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_passwordNotification" object:nil];
}
@end
