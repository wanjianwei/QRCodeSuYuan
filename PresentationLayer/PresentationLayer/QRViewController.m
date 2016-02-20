//
//  QRViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-30.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "QRViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface QRViewController ()
{
    //定义一个变量，用来存储二维码中的视频网址
    NSString*vedioPath;
}

@end

@implementation QRViewController

//预定义业务逻辑层
BusinessLogicLayer*layer;
//扫描得到的二维码信息

NSString *stringValue;

-(void)viewDidLoad

{
    [super viewDidLoad];
    //初始化业务逻辑层
    layer=[BusinessLogicLayer shareManaged];
     self.view.backgroundColor = [UIColor grayColor];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(120, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 350, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(70, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_GoodsInfo:) name:@"return_dataNotification" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //释放对象，节约内存
    self.device=nil;
    self.input=nil;
    self.output=nil;
    self.session=nil;
    self.preview=nil;
    self.line=nil;
   [super viewDidDisappear:animated];
  //  self.place=nil;
}


-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(70, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(70, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(40,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //在此处得到二维码编码信息，将商品Tag和视频网址分割
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        //将得到的二维码数据分割成商品tag和视频网址
       // vedioPath=[[stringValue componentsSeparatedByString:@"@"] objectAtIndex:1];

        //向服务器发送扫描得到的商品Tag信息
        [layer customer_Query:[[stringValue componentsSeparatedByString:@"@"] objectAtIndex:0]];
    }
    
   
}

//二维码扫描——接受服务器返回信息，并跳转到商品信息页面
-(void)return_GoodsInfo:(NSNotification*)notification
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
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:return_string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if(flag1==1)
    {
        //信息返回成功，则显示“商品信息”模块，
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        GoodsInfoViewController*good_info=[main instantiateViewControllerWithIdentifier:@"goods_info"];
        good_info.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        NSArray*array=[return_string componentsSeparatedByString:@"#"];
        //将解析得到的数据传送给下一个模块
        good_info.array_info=array;
        //将二维码扫描得到的信息传递给下一模块，以作为其发送给服务器的发送字段
        good_info.QRsendString=[[stringValue componentsSeparatedByString:@"@"] objectAtIndex:0];
        //将视频网址传递给下一个模块
      //  good_info.vedioPath=[[stringValue componentsSeparatedByString:@"@"] objectAtIndex:1];
        //产生系统提示音
        AudioServicesPlaySystemSound(1000);
        [self presentViewController:good_info animated:YES completion:nil];
    }
    //停止扫描
    [_session stopRunning];
    [timer invalidate];
    //解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"return_dataNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
