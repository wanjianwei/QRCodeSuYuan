//
//  RegisterViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-4.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "RegisterViewController.h"
#import "Register_secViewController.h" //返回上一个注册模块的头文件
#import "LeafNotification.h"
#import "ViewController.h"
#import "LeafNotification.h"
#define port1 8808
@interface RegisterViewController ()
@end
@implementation RegisterViewController
BusinessLogicLayer*layer;  //预定义业务逻辑层，负责网络通信和数据包头部整合
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置“下一步”按钮的类型
    [self.nextStep successStyle];
    layer=[BusinessLogicLayer shareManaged];//实例化业务逻辑层，单例模式

    //定义一个轻击手势处理器，为的是轻击背景来关闭图片
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkbreak) name:@"networkbreakNotification" object:nil];
    //注册连接服务器成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"ConnectSucessNotification" object:nil];
    //注册连接服务器失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail) name:@"ConnectFailedNotification" object:nil];
    
}

//通知响应方法

//响应通知方法
-(void)connectSuccess
{
    [LeafNotification showInController:self withText:@"服务器连接成功"];
   
}

-(void)connectFail
{
    [LeafNotification showInController:self withText:@"服务器连接失败"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    //背景图片在此处加载是为了节省内存
    NSString*path=[[NSBundle mainBundle] pathForResource:@"register_bg1" ofType:@"png"];
    self.register_bg.image=[[UIImage alloc] initWithContentsOfFile:path];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"networkbreakNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    //释放对象，节约内存
    self.register_bg=nil;
    self.customer_email=nil;
    self.realname=nil;
    self.customer_password=nil;
    self.customer_name=nil;
    self.phoneNum=nil;
    self.verifyNum=nil;
    [super viewDidDisappear:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
}


//验证码填写完毕，完成注册功能,
- (IBAction)nextStep:(id)sender
{
    //关闭键盘
    [self.verifyNum resignFirstResponder];
    //注册接收返回数据的通知是第一步
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_state:) name:@"return_dataNotification" object:nil];
    if ([self.verifyNum.text isEqual:@""])
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if(layer.socket1.isConnected==NO)
    {
        
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接已断开,是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"确定",nil];
        [alert show];
    }
    else
    {
        NSString*sendstring=[NSString stringWithFormat:@"%@#%@#%@",self.customer_name,self.phoneNum.text,self.verifyNum.text];
        [layer customer_submitVerifyNum:sendstring];
    }
}

//对通知的处理方法,之后一定要解除通知
-(void)return_state:(NSNotification*)notification
{
    //取出通知中的传送数据
    NSDictionary*dic=[notification userInfo];
    NSString*content=[dic objectForKey:@"return_string"];
    //取出成功或失败标志
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==1)
    {
      //  [self.view.window showHUDWithText:@"注册成功" Type:ShowPhotoYes Enabled:YES];
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Congracts!" message:@"注册成功，是否返回登录页面" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag=2;
        [alert show];
        
    }
    else if (flag1==2)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

//填写电话号码，捆绑上一个界面填写的信息后发送给服务器，并等待接收错误提示或成功后的验证码

- (IBAction)sendNum:(id)sender
{
    [self.phoneNum resignFirstResponder];
    //在这就直接注册通知，返回数据处理完后解除通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_verifynum:) name:@"return_dataNotification" object:nil];
    if ([self.phoneNum.text isEqualToString:@""])
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    else if (layer.socket1.isConnected==NO)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接已断开，是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag=1;
        [alert show];
    }
    else
    {
        NSString*send=[NSString stringWithFormat:@"%@#%@#%@#%@#%@",self.customer_name,self.customer_password,self.realname,self.phoneNum.text,self.customer_email];
          [layer customer_Register:send];
    }
}
//发送电话号码后，接收通知，并对通知返回的数据进行处理,之后必须解除通知
-(void)return_verifynum:(NSNotification*)notification
{
    //取出返回字符串
    NSDictionary*dic=[notification userInfo];
    NSString*content=[dic objectForKey:@"return_string"];
  //取出标志
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==1)
    {
        [LeafNotification showInController:self withText:@"验证码已发送" type:LeafNotificationTypeSuccess];
        
    }
    else
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

//返回上一个注册页面
- (IBAction)back:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)networkbreak
{
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接中断" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


//轻击手势处理器的响应方法。点击背景，关闭键盘
-(void)dismissKeyboard
{
    [self.phoneNum resignFirstResponder];
    [self.verifyNum resignFirstResponder];
}

//UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
        }

    }
    else if (alertView.tag==2)
    {
        if (buttonIndex==0)
        {
            UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            ViewController*view=[main instantiateViewControllerWithIdentifier:@"FirstViewController"];
            view.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            view.username.text=self.customer_name;
            view.password.text=self.customer_password;
            [self presentViewController:view animated:YES completion:nil];
        }
    }
}

@end
