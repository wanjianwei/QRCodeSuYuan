//
//  ViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#define port1 8808
@implementation ViewController
CGFloat imageSize; //自定义头像的半径
BusinessLogicLayer*layer;//业务逻辑层，负责数据包打包和连接网络
//用来保存ip
NSString*ip;
//自定义的圆形头像
PAImageView*portrait;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //自定义动态按钮strapButton型
    [self.login successStyle];
    //设置活动指示器的属性
    self.activityindicator.hidesWhenStopped=YES;
    //添加圆形头像
    imageSize=100.0f;
    portrait=[[PAImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-imageSize)/2, (self.view.bounds.size.height-imageSize)/2-200, imageSize, imageSize) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    [portrait updateWithImage:[UIImage imageNamed:@"morentouxiang.jpg"] animated:YES];
    [self.view addSubview:portrait];
    //初始化业务逻辑层
    layer=[BusinessLogicLayer shareManaged];
    //注册一个手势处理器，为的是点击视图背景，关闭键盘,并未设置其接受多点触碰，所以默认只接受单击
    UIGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];
    
}

//在视图即将出现时注册接受通知
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载背景图片
    NSString*path=[[NSBundle mainBundle] pathForResource:@"login_bg1" ofType:@"jpg"];
    self.login_bg.image=[[UIImage alloc] initWithContentsOfFile:path];
    //注册接受通知，此通知在业务逻辑层注册，为观察者模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakDown:) name:@"ConnectBreakDownNotification" object:nil];
    
    //接收服务器连接中途断开通
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkbreak:) name:@"networkbreakNOtification" object:nil];
    //服务器连接成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"ConnectSucessNotification" object:nil];
    //注册服务器连接失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail) name:@"ConnectFailedNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];

}

-(void)viewDidDisappear:(BOOL)animated
{
    self.login_bg=nil;
    //解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectBreakDownNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"networkbreakNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    
     [super viewDidDisappear:NO];
}

//连接服务器
- (IBAction)server_link:(id)sender
{
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"连接服务器" message:@"请输入服务器域名或IP" delegate:self cancelButtonTitle:nil otherButtonTitles:@"连接",@"取消",nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] isEqualToString:@""])
    {
        [alert textFieldAtIndex:0].placeholder=@"IP/域名";
    }
    else
    {
        [alert textFieldAtIndex:0].text=[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"];
    }
    
    [alert textFieldAtIndex:0].secureTextEntry=NO;
    [alert show];
}

//服务器连接成功
-(void)connectSuccess
{
    //持久化保存ip
    [[NSUserDefaults standardUserDefaults] setObject:ip forKey:@"IP"];
    [LeafNotification showInController:self withText:@"服务器连接成功" type:LeafNotificationTypeSuccess];
}

//服务器连接失败
-(void)connectFail
{
    ip=nil;
    [LeafNotification showInController:self withText:@"服务器连接失败"];
}


//执行登陆操作
- (IBAction)login:(id)sender
{
    //注册接收连接成功后数据返回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_data:) name:@"return_dataNotification" object:nil];
    //注册接受服务器发送的用户名和等级通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_nameAndlevel:) name:@"return_name&level" object:nil];
    
    //如果找回密码说明框有字符，则先置为空
    if (![self.passwordReturnInfo.text isEqual:@""])
    {
        self.passwordReturnInfo.text=nil;
    }
    
    //用户名或密码为空时显示此警告信息
    if ([self.password.text isEqual:@""]||[self.username.text isEqual:@""])
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
       
    }
    else if (layer.socket1.isConnected==NO) //若在登录时发现服务器未连接，显示此提示消息
    {
        
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器尚未连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
       [self.activityindicator startAnimating];
        [self.login setTitle:@"" forState:UIControlStateNormal];
        NSString*send=[NSString stringWithFormat:@"%@#%@",self.username.text,self.password.text];
        [layer customer_Login:send];
    }
}



//返回登录信息处理
-(void)return_data:(NSNotification*)notification
{
    //取出通知中的传送数据
    NSDictionary*dic=[notification userInfo];
    NSString*content=[dic objectForKey:@"return_string"];
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==1)
    {
        
        //登录成功，将用户名及密码存储起来
        [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
        //活动指示器停止，登陆按钮标题恢复
        [self.activityindicator stopAnimating];
        [self.login setTitle:@"登录" forState:UIControlStateNormal];
        //登陆验证成功，进入“功能首页”页面
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        FirstViewController*firstView=[main instantiateViewControllerWithIdentifier:@"first"];
        firstView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        //设定firstView的flag属性为1，以控制进入该页面是“登录成功”HUB显示一次
        firstView.flag=1;
        [self presentViewController:firstView animated:YES completion:nil];
        //将登录界面的用户名及密码清空
      //  self.username.text=nil;
        self.password.text=nil;
      
    }
    else
    {
        //活动指示器停止，登陆按钮标题恢复
        [self.activityindicator stopAnimating];
        [self.login setTitle:@"登录" forState:UIControlStateNormal];
    
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    //解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

//返回用户名和用户等级处理
-(void)return_nameAndlevel:(NSNotification*)notification
{
    //取出通知中的传送数据
    NSDictionary*dic=[notification userInfo];
    NSData*user_name=[dic objectForKey:@"user_name"];
    NSNumber*user_level=[dic objectForKey:@"user_level"];
    [[NSUserDefaults standardUserDefaults] setObject:user_name forKey:@"user_name"];
    [[NSUserDefaults standardUserDefaults] setObject:user_level forKey:@"user_level"];

}

//获取返回密码操作
- (IBAction)getPassword:(id)sender
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_password:) name:@"return_passwordNotification" object:nil];  //连接成功，密码数据返回通知
    //如果找回密码说明框有字符，则置为空
    if (![self.passwordReturnInfo.text isEqual:@""])
    {
        self.passwordReturnInfo.text=nil;
    }
    
    //若服务器尚未连接，则弹出警告框
    if (layer.socket1.isConnected==NO)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器尚未连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    else
  {
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"找回密码" message:@"请输入注册电话及邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
     [alert textFieldAtIndex:0].placeholder=@"电话号码";
    [alert textFieldAtIndex:1].placeholder=@"邮箱";
    [alert textFieldAtIndex:1].secureTextEntry=NO;
    [alert show];
   }
}

//登陆密码输入框的明文与暗文转换

- (IBAction)mingwenChang:(id)sender
{
    if (self.password.secureTextEntry==YES) {
        self.password.secureTextEntry=NO;
    }
    else
        self.password.secureTextEntry=YES;
}

//接受return_passwordNOtification后的响应方法
-(void)return_password:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==1)
    {
        //将返回用户名与密码分开
    //    NSArray*array=[[NSArray alloc] init];
       NSArray* array=[return_string componentsSeparatedByString:@"#"];
        //把用户名及密码都写上登陆框
        self.password.text=[array objectAtIndex:2];
        self.username.text=[array objectAtIndex:1];
        self.passwordReturnInfo.text=@"密码找回成功";
    }
    else
        self.passwordReturnInfo.text=return_string;
    //返回密码账户完成后即移除此通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_passwordNotification" object:nil];
}

//当接收到networkbreak通知时，调用该方法
-(void)networkbreak:(NSNotification*)notification
{
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接中断，请重新连接网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


//接受服务器中途断开连接的通知时响应的方法
-(void)connectBreakDown:(NSNotification*)notification
{
    UIAlertView*alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接中断，请重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}


//pragamark---UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击背景，关闭键盘
-(void)keyboardHide
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

//点击注册按钮，模态呈现Register_secViewController

- (IBAction)register1:(id)sender
{
    if(layer.socket1.isConnected==NO)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器尚未连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    Register_secViewController*register_sec=[[Register_secViewController alloc] init];
    register_sec.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:register_sec animated:YES completion:nil];
    }
}

//UIAlertView Delegate此处分为两个部分1、找回密码 2、连接服务器
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle==UIAlertViewStyleLoginAndPasswordInput)
 {
    if (buttonIndex==0)
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]||[[alertView textFieldAtIndex:1].text isEqualToString:@""])
        {
            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱或电话号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
           
        }
        else
        {
          NSString*send=[NSString stringWithFormat:@"%@#%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
          [layer customer_GetPassword:send];
        }
        
    }
     else if (buttonIndex==1)
         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_passwordNotification" object:nil];
 }
    else if (alertView.alertViewStyle==UIAlertViewStylePlainTextInput)
    {
        if (buttonIndex==0)
        {
            layer.host=[alertView textFieldAtIndex:0].text;
            ip=layer.host;
            layer.port=port1;
            [layer connectWithIp:layer.host AndPort:layer.port];
        }
    }
}

@end
