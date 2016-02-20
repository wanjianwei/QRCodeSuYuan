//
//  QRViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-30.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BusinessLogicLayer.h"
#import "GoodsInfoViewController.h"
#import "GoodsInfoViewController.h"
@interface QRViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
//接受上个模块传来的经纬度
// @property(assign,nonatomic)NSDictionary*place;

@end
