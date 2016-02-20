//
//  GoodsInfoViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-16.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "LogisticsViewController.h"
#import "FirstViewController.h"
#import "LeafNotification.h"
#import "CommentViewController.h"
#define port1 8808
@interface GoodsInfoViewController ()
{
    BusinessLogicLayer*layer;
    UILabel*label1,*label2,*label3,*label4,*label5,*label6,*label7,*label8,*label9,*label10;
    UILabel*label_1,*label_2,*label_3,*label_4,*label_5,*label_6,*label_7,*label_8,*label_9,*label_10;
    UIButton*button;
}

@end

@implementation GoodsInfoViewController


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

    //初始化业务逻辑层
    layer=[BusinessLogicLayer shareManaged];
    //设置动画显示属性
    [self.goods_display setAnimationDuration:7];
    //循环无数次
    [self.goods_display setAnimationRepeatCount:HUGE_VALF];
    //当前得分
    self.goods_score.text=[NSString stringWithFormat:@"%@分",[self.array_info objectAtIndex:10]];
    //显示打分控件
    Star *star1 = [[Star alloc] initWithFrame:CGRectMake(9.0f, 343.0f, 93.0f, 30.0f)];
    star1.show_star =[[self.array_info objectAtIndex:10] floatValue]*20;
    star1.font_size = 15;
    [self.view addSubview:star1];
    //电话、评分人数补充
    self.goods_price.text=[NSString stringWithFormat:@"%@元",[self.array_info objectAtIndex:9]];
    self.goods_evaluate.text=[NSString stringWithFormat:@"共%@条",[self.array_info objectAtIndex:11]];
    self.goods_index.text=[self.array_info objectAtIndex:12];
    [self.phoneNum setTitle:[self.array_info objectAtIndex:14] forState:UIControlStateNormal];
    [self.phoneNum setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
 
    //基本信息滑动页面
    self.basic_info.contentSize=CGSizeMake(375, 600);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    //滑动页面添加控件
    label1=[[UILabel alloc] initWithFrame:CGRectMake(15, 25, 80, 25)];
    label1.text=@"商品名称：";
    label1.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label1];
    label_1=[[UILabel alloc] initWithFrame:CGRectMake(95, 25, 255, 25)];
    label_1.numberOfLines=0;
    label_1.font=[UIFont boldSystemFontOfSize:15];
    label_1.text=[self.array_info objectAtIndex:0];
    [self.basic_info addSubview:label_1];
    
    label2=[[UILabel alloc] initWithFrame:CGRectMake(15, 60, 80, 25)];
    label2.text=@"出厂日期：";
    label2.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label2];
    label_2=[[UILabel alloc] initWithFrame:CGRectMake(95, 60, 255, 25)];
    label_2.numberOfLines=0;
    label_2.font=[UIFont boldSystemFontOfSize:15];
    label_2.text=[self.array_info objectAtIndex:1];
    [self.basic_info addSubview:label_2];
    
    label3=[[UILabel alloc] initWithFrame:CGRectMake(15, 95, 80, 25)];
    label3.text=@"保存期限：";
    label3.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label3];
    label_3=[[UILabel alloc] initWithFrame:CGRectMake(95, 95, 255, 25)];
    label_3.numberOfLines=0;
    label_3.font=[UIFont boldSystemFontOfSize:15];
    label_3.text=[self.array_info objectAtIndex:2];
    [self.basic_info addSubview:label_3];
    
    label4=[[UILabel alloc] initWithFrame:CGRectMake(15, 130, 80, 25)];
    label4.text=@"商品种类：";
    label4.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label4];
    label_4=[[UILabel alloc] initWithFrame:CGRectMake(95, 130, 255, 25)];
    label_4.numberOfLines=0;
    label_4.font=[UIFont boldSystemFontOfSize:15];
    label_4.text=[self.array_info objectAtIndex:3];
    [self.basic_info addSubview:label_4];
    
    label5=[[UILabel alloc] initWithFrame:CGRectMake(15, 165, 80, 25)];
    label5.text=@"生产厂家：";
    label5.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label5];
    label_5=[[UILabel alloc] initWithFrame:CGRectMake(95, 165, 255, 25)];
    label_5.numberOfLines=0;
    label_5.font=[UIFont boldSystemFontOfSize:15];
    label_5.text=[self.array_info objectAtIndex:4];
    [self.basic_info addSubview:label_5];
    
    label6=[[UILabel alloc] initWithFrame:CGRectMake(15, 200, 80, 80)];
    label6.text=@"商品描述：";
    label6.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label6];
    label_6=[[UILabel alloc] initWithFrame:CGRectMake(95, 200, 255, 80)];
    label_6.numberOfLines=0;
    label_6.font=[UIFont boldSystemFontOfSize:15];
    label_6.text=[self.array_info objectAtIndex:5];
    [self.basic_info addSubview:label_6];
    
    label7=[[UILabel alloc] initWithFrame:CGRectMake(15, 290, 90, 40)];
    label7.text=@"部件/成分：";
    label7.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label7];
    label_7=[[UILabel alloc] initWithFrame:CGRectMake(95, 290, 255, 40)];
    label_7.numberOfLines=0;
    label_7.font=[UIFont boldSystemFontOfSize:15];
    label_7.text=[self.array_info objectAtIndex:6];
    [self.basic_info addSubview:label_7];
    
    label8=[[UILabel alloc] initWithFrame:CGRectMake(15, 340, 80, 60)];
    label8.text=@"使用说明：";
    label8.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label8];
    label_8=[[UILabel alloc] initWithFrame:CGRectMake(95, 340, 255, 60)];
    label_8.numberOfLines=0;
    label_8.font=[UIFont boldSystemFontOfSize:15];
    label_8.text=[self.array_info objectAtIndex:7];
    [self.basic_info addSubview:label_8];
    
    label9=[[UILabel alloc] initWithFrame:CGRectMake(15, 410, 80, 80)];
    label9.text=@"注意事项：";
    label9.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label9];
    label_9=[[UILabel alloc] initWithFrame:CGRectMake(95, 410, 255, 80)];
    label_9.numberOfLines=0;
    label_9.font=[UIFont boldSystemFontOfSize:15];
    label_9.text=[self.array_info objectAtIndex:8];
    [self.basic_info addSubview:label_9];
    
    label10=[[UILabel alloc] initWithFrame:CGRectMake(15, 500, 120, 25)];
    label10.text=@"最后更新时间：";
    label10.font=[UIFont boldSystemFontOfSize:15];
    [self.basic_info addSubview:label10];
    label_10=[[UILabel alloc] initWithFrame:CGRectMake(125, 500, 245, 25)];
    label_10.numberOfLines=0;
    label_10.font=[UIFont boldSystemFontOfSize:15];
    label_10.text=[self.array_info objectAtIndex:13];
    [self.basic_info addSubview:label_10];
    //在此处添加一个按钮，点击该按钮，则进行视频播放
    button=[[UIButton alloc] initWithFrame:CGRectMake(25, 540, 325, 40)];
    [button addTarget:self action:@selector(watchVedio) forControlEvents:UIControlEventTouchUpInside];
    //定义按钮的外观
    button.layer.cornerRadius=4.0f;
    button.layer.borderWidth=2.0f;
    button.layer.borderColor=[[UIColor blackColor] CGColor];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"观看视频" forState:UIControlStateNormal];
    [self.basic_info addSubview:button];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //释放强引用对象，节约内存
    self.goods_display.animationImages=nil;
    self.basic_info=nil;
    label1=nil;label2=nil;label3=nil;label4=nil;label5=nil;
    label6=nil;label7=nil;label8=nil;label9=nil;label10=nil;
    label_1=nil;label_2=nil;label_3=nil;label_4=nil;label_5=nil;
    label_6=nil;label_7=nil;label_8=nil;label_9=nil;label_10=nil;
    //清除临时缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
     [super viewWillDisappear:NO];
    
}
//view Did Load只能装载一次，而viewWillAppear可以调用多次
-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:NO];
    
    NSArray*array=[self.QRsendString componentsSeparatedByString:@"#"];
    //给界面各个控件写入信息(商品展示滑动页面)
    if ([[array objectAtIndex:3] isEqualToString:@"0010101001"])
    {
        self.goods_display.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"iphone_1.png"],[UIImage imageNamed:@"iphone_2.png"],[UIImage imageNamed:@"iphone_3.png"] ,nil];
    }
    else if ([[array objectAtIndex:3] isEqualToString:@"0030201001"])
    {
        self.goods_display.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"maotai1.png"],[UIImage imageNamed:@"maotai2.png"],[UIImage imageNamed:@"maotai3.png"] ,nil];
    }
    else if ([[array objectAtIndex:3] isEqualToString:@"0010301001"])
    {
        self.goods_display.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"mic1.png"],[UIImage imageNamed:@"mic2.png"],[UIImage imageNamed:@"mic3.png"] ,nil];
    }
        //显示动画
    [self.goods_display startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
}

//点击按钮，开始观看视频
-(void)watchVedio
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"在线观看视频将会消耗大量流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action_yes=[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
    {
        if (_moviePlayer==nil)
        {
           
            _moviePlayer=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://7u2r6b.com1.z0.glb.clouddn.com/AppleMacBookAir.mp4"]];
            _moviePlayer.moviePlayer.scalingMode=MPMovieScalingModeAspectFill;
            _moviePlayer.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
            //点击Done按钮，视频会推出全屏，并发出通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressDone:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
            
            //注册监听下载状态
            /*
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:)name:MPMoviePlayerLoadStateDidChangeNotification
                                                       object:nil];
             */
        }
        
        [self presentViewController:_moviePlayer animated:YES completion:nil];
        
    }];
    UIAlertAction*action_no=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action_no];
    [alert addAction:action_yes];
    [self presentViewController:alert animated:YES completion:nil];
}

//视频播放完成后的调用方法
-(void)playFinish:(NSNotification*)notification
{
    //取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.moviePlayer dismissMoviePlayerViewControllerAnimated];
    self.moviePlayer=nil;
}

//推出全屏通知-在此结束播放
-(void)pressDone:(NSNotification*)noti
{
    [self.moviePlayer dismissMoviePlayerViewControllerAnimated];
    self.moviePlayer=nil;
}

/*
//监听播放状态
-(void)moviePlayerLoadStateChanged:(NSNotification*)noti
{
    if (self.moviePlayer.moviePlayer.loadState==MPMovieLoadStateUnknown)
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"播放格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
*/
- (IBAction)back:(id)sender
{
    self.array_info=nil;
    self.QRsendString=nil;
    UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FirstViewController*view=[main instantiateViewControllerWithIdentifier:@"first"];
    view.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:view animated:YES completion:nil];
    
}

- (IBAction)logistics:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
        //注册连接服务器成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"ConnectSucessNotification" object:nil];
        //注册连接服务器失败通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail) name:@"ConnectFailedNotification" object:nil];
        
        //直接连接服务器
        [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];
        
        /*
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器已断开，是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag=1;
        [alert show];
         */
    }
    else
    {
       //注册接受服务器返回数据通知
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_logistics:) name:@"return_dataNotification" object:nil];
       //向服务器发送请求，获取物流信息，并在信息返回成功后跳转到物流地图界面
       //发送的字符串是二维码扫描到得字符串
       NSString*send=self.QRsendString;
       [layer customer_logistics:send];
    }
}

//响应通知方法
-(void)connectSuccess
{
   // [LeafNotification showInController:self withText:@"服务器连接成功" type:LeafNotificationTypeSuccess];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    
    //向服务器发送请求
    //注册接受服务器返回数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_logistics:) name:@"return_dataNotification" object:nil];
    //向服务器发送请求，获取物流信息，并在信息返回成功后跳转到物流地图界面
    //发送的字符串是二维码扫描到得字符串
    NSString*send=self.QRsendString;
    [layer customer_logistics:send];
}

-(void)connectFail
{
   // [LeafNotification showInController:self withText:@"服务器连接失败"];
     UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器已断开，是否重新连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
     alert.tag=1;
     [alert show];
}


//拨打电话
- (IBAction)phoneNum:(id)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[self.phoneNum titleLabel].text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

//查看评论列表
- (IBAction)checkcomments:(id)sender
{
    if (layer.socket1.isConnected==NO)
    {
        //注册连接服务器成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess1) name:@"ConnectSucessNotification" object:nil];
        //注册连接服务器失败通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFail) name:@"ConnectFailedNotification" object:nil];
        //直接连接服务器
        [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:port1];

    }
    else
    {
        //注册接受服务器返回数据通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_comments:) name:@"return_dataNotification" object:nil];
        //向服务器发送请求，获取物流信息，并在信息返回成功后跳转到物流地图界面
        //发送的字符串是二维码扫描到得字符串
        NSArray*array=[self.QRsendString componentsSeparatedByString:@"#"];
        //将tagID持久化存储
        [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:3] forKey:@"tagID"];
        NSString*send=[NSString stringWithFormat:@"%@#0",[array objectAtIndex:3]];
        [layer customer_checkcomments:send];
    }
}

//另外在设定通知响应方法(成功连接服务器)，是为了区别logistic的;
-(void)connectSuccess1
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectSucessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConnectFailedNotification" object:nil];
    //注册接受服务器返回数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_comments:) name:@"return_dataNotification" object:nil];
    //向服务器发送请求，获取物流信息，并在信息返回成功后跳转到物流地图界面
    //发送的字符串是二维码扫描到得字符串
    NSArray*array=[self.QRsendString componentsSeparatedByString:@"#"];
    //将tagID持久化存储
    [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:3] forKey:@"tagID"];
    NSString*send=[NSString stringWithFormat:@"%@#0",[array objectAtIndex:3]];
    [layer customer_checkcomments:send];
}

//接受通知返回信息，成功后跳转到下一个视图“用户评论”
-(void)return_comments:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    //如果出错
    if (flag1==2)
    {
        UIAlertView*view=[[UIAlertView alloc] initWithTitle:@"提示" message:return_string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    }
    else if(flag1==1)
    {
        //信息返回成功，则显示“物流信息”模块，
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        CommentViewController*commentView=[main instantiateViewControllerWithIdentifier:@"commentView"];
        commentView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        //将返回字符串变成数组，传递给评论模块
        NSArray*array=[return_string componentsSeparatedByString:@"#"];
        commentView.Allcomment=array;
        [self presentViewController:commentView animated:YES completion:nil];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}


//接收通知返回信息,成功后跳转到下一个视图“物流信息”
-(void)return_logistics:(NSNotification*)notification
{
    //取出通知传送的数据
    NSDictionary*dic=[notification userInfo];
    //取出返回字符串
    NSString*return_string=[dic objectForKey:@"return_string"];
    NSArray*array=[return_string componentsSeparatedByString:@"#"];
    //取出成功标志sucess_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    //如果出错
    if (flag1==2)
    {
        UIAlertView*view=[[UIAlertView alloc] initWithTitle:@"提示" message:return_string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
    }
    else if(flag1==1)
    {
        //信息返回成功，则显示“物流信息”模块，
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LogisticsViewController*LogisticView=[main instantiateViewControllerWithIdentifier:@"logisticsview"];
        LogisticView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        LogisticView.goods_logistics=array;
        [self presentViewController:LogisticView animated:YES completion:nil];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
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

}
@end
