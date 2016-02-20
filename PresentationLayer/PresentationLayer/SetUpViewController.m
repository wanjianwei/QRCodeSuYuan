//
//  SetUpViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-19.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "SetUpViewController.h"
@interface SetUpViewController ()

@end

@implementation SetUpViewController
int level;//定义用户等级
NSData*customer_id;//定义用户名
//定义业务逻辑层
BusinessLogicLayer*layer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化业务逻辑层
    layer=[BusinessLogicLayer shareManaged];
      //按钮显示的形式
    [self.changePasswrd successStyle];
    [self.changePhoneNum successStyle];
    
    //构造显示头像
   float  imageSize=105.0f;
  PAImageView * portrait=[[PAImageView alloc]initWithFrame:CGRectMake(22,90,imageSize, imageSize) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    [portrait updateWithImage:[UIImage imageNamed:@"morentouxiang.jpg"] animated:YES];
   //头像加载到滚动视图上
    [self.view addSubview:portrait];
    level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] intValue];
    customer_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSString*path=[[NSBundle mainBundle] pathForResource:@"setup_bg1" ofType:@"png"];
    self.setup_bg.image=[[UIImage alloc] initWithContentsOfFile:path];
    //加载用户信息
    self.userName.text=[NSString stringWithFormat:@"用户名：%@",[self.user_info objectAtIndex:1]];
    self.realName.text=[self.user_info objectAtIndex:3];
    self.password.text=[self.user_info objectAtIndex:2];
    self.telNum.text=[self.user_info objectAtIndex:4];
    self.email.text=[self.user_info lastObject];
    self.customer_id.text=[NSString stringWithFormat:@"用户ID：%@",customer_id];
    if (level==5)
        self.level.text=@"common";
    else if (level==6)
        self.level.text=@"special_one";
    else if (level==7)
        self.level.text=@"special_two";
    else if (level==8)
        self.level.text=@"special_three";
    else
        self.level.text=@"vip";
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.user_info=nil;
    self.setup_bg=nil;
    self.userName=nil;
    self.email=nil;
    self.telNum=nil;
    self.level=nil;
    self.customer_id=nil;
    self.password=nil;
    [super viewDidDisappear:animated];
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//功能尚未实现
- (IBAction)reserve:(id)sender
{
    
}

//改变密码
- (IBAction)changePassword:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
        
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接已断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_changepassword:) name:@"return_dataNotification" object:nil];  //连接成功，密码数据返回通知
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"修改密码" message:@"请输入当前密码及新密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"修改",@"取消",nil];
    //为alert设定一个tag
    alert.tag=0;
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder=@"当前密码";
    [alert textFieldAtIndex:1].placeholder=@"新密码";
    [alert textFieldAtIndex:1].secureTextEntry=NO;
    [alert show];
    }
}

-(void)return_changepassword:(NSNotification*)notification
{
    NSDictionary*dic=[notification userInfo];
    NSNumber *flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    
    if (flag1==1)
    {
        
        self.password.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"newpassword"];
        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
        
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"newpassword"];
        
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

- (IBAction)changePhoneNum:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
                
        //消息提示
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接已断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    else
  {
    //注册接受通知，等待修改返回信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_changePhoneNum:) name:@"return_dataNotification" object:nil];
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"修改绑定电话" message:@"请输入当前电话及新电话号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"修改",@"取消",nil];
    //为其设定一个tag，以用来区别修改密码
    alert.tag=1;
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder=@"当前电话号码";
    [alert textFieldAtIndex:1].placeholder=@"新电话号码";
    [alert textFieldAtIndex:1].secureTextEntry=NO;
    [alert show];
  }
}

-(void)return_changePhoneNum:(NSNotification*)notification
{
    NSDictionary*dic=[notification userInfo];
    NSNumber *flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    
    if (flag1==1)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

        self.telNum.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"newphonenum"];
        
    }
    else
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"newphonenum"];
    }
    
    //数据接受完成，则解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

//UIAlertViewDelegate协议

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)   //修改密码
    {
         if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[alertView textFieldAtIndex:1].text forKey:@"newpassword"];
            NSString*send=[NSString stringWithFormat:@"%@#%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
            [layer customer_changePassword:send];
        
        }
    }
    else if (alertView.tag==1)   //修改电话号码
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[alertView textFieldAtIndex:1].text forKey:@"newphonenum"];
            NSString*send=[NSString stringWithFormat:@"%@#%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
            [layer customer_changePhoneNum:send];
            
        }
    }
}
@end
