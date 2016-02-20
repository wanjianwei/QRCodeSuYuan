//
//  FirstViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-13.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "QRViewController.h"
#import "LeafNotification.h"
#define port1 8808
@interface FirstViewController ()

@end

@implementation FirstViewController

//预定义业务逻辑层
BusinessLogicLayer*layer;
//用来存储当前用户最近一次的经纬度
NSNumber *latitude;
NSNumber*longitude;
//定义一个字典型数据，用来存放地址经纬度信息
NSDictionary*location;
//定义一个字符串，用来存放二维码扫描到的字段
NSString*QRString;

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
    //对业务逻辑层进行初始化，其为单例模式。
    layer=[BusinessLogicLayer shareManaged];
    //初始化定位管理器
    self.locationManager=[[CLLocationManager alloc] init];
    //设置定位管理器属性
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSString*path1=[[NSBundle mainBundle] pathForResource:@"function_bg1" ofType:@"png"];
    self.function_bg.image=[[UIImage alloc] initWithContentsOfFile:path1];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    //第一次登陆功能主界面时，才能显示HUB
    if (self.flag==1)
  {
    [LeafNotification showInController:self withText:@"登录成功" type:LeafNotificationTypeSuccess];
        self.flag=0;
  }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    //释放对象，节约内存
    self.function_bg=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
}

//响应通知方法
-(void)connectSuccess
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    
    //注册接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_userInfo:) name:@"return_dataNotification" object:nil];
    [layer customer_returnInfo:[NSString stringWithFormat:@"%@#%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
}

-(void)connectFail
{
    //失败了应该再次连接
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接失败，是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
//进入nfc功能界面
- (IBAction)nfc_search:(id)sender
{
    [LeafNotification showInController:self withText:@"该功能尚未实现"];
}


//进入二维码扫描界面
- (IBAction)QR_search:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
        //注册连接服务器成功通知--处理方法要不一样，已区别setup方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess1) name:@"ConnectSucessNotification" object:nil];
        //注册连接服务器失败通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail1) name:@"ConnectFailedNotification" object:nil];
        //直接重新链接
        [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
    }
    else
    {
       QRViewController*view=[[QRViewController alloc] init];
       [self presentViewController:view animated:YES completion:nil];
    }
}

//通知处理方法
-(void)connectSuccess1
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    //连接成功，打开相机
    QRViewController*view=[[QRViewController alloc] init];
    [self presentViewController:view animated:YES completion:nil];
}
-(void)connectFail1
{
    //重新链接
    //[layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
    //失败了应该再次连接
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接失败，是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
//进入用户设置界面
- (IBAction)setUp:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
        //注册连接服务器成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"ConnectSucessNotification" object:nil];
        //注册连接服务器失败通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail) name:@"ConnectFailedNotification" object:nil];
        
        //直接重新链接
        [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
    }
    else
    {
        //注册接受通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_userInfo:) name:@"return_dataNotification" object:nil];
        [layer customer_returnInfo:[NSString stringWithFormat:@"%@#%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
    }
}

//响应方法，将返回的用户信息传递给下一个模块
-(void)return_userInfo:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_info=[dic objectForKey:@"return_string"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==2)
    {
        //错误提示
         [LeafNotification showInController:self withText:@"用户设置界面加载失败"];
    }
    else if (flag1==1)
    {
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        SetUpViewController*setupView=[main instantiateViewControllerWithIdentifier:@"setup_view"];
        setupView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        setupView.user_info=[return_info componentsSeparatedByString:@"#"];
        [self presentViewController:setupView animated:YES completion:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

//退出，关闭socket
- (IBAction)back:(id)sender
{
    //退出后要下线，需要向服务器发送消息，以通知服务器改变状态
    if (layer.socket1.isConnected==YES)
    {
        [layer.socket1 setDelegate:nil];
        [layer.socket1 disconnect];
    }
    UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
       ViewController*View=[main instantiateViewControllerWithIdentifier:@"FirstViewController"];
    View.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:View animated:YES completion:nil];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
}
/*
//成功获取定位数据后将会激发该方法，由于在iPhone4s上无法获得经纬度，所以暂时不用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation*loc=[locations lastObject];
    latitude=[NSNumber numberWithDouble:loc.coordinate.latitude];
    longitude=[NSNumber numberWithDouble:loc.coordinate.longitude];
   location=[NSDictionary dictionaryWithObjectsAndKeys:latitude,@"latitude",longitude,@"longtitude", nil];
    
}
*/
//UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
    }
}
@end
