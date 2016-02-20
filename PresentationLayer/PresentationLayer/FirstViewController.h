//
//  FirstViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-13.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIWindow+YzdHUD.h"
#import "BusinessLogicLayer.h"
#import "GoodsInfoViewController.h"
#import "SetUpViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>

- (IBAction)back:(id)sender;

- (IBAction)nfc_search:(id)sender;

- (IBAction)QR_search:(id)sender;
- (IBAction)setUp:(id)sender;

//添加一个定位管理器
@property(nonatomic,strong)CLLocationManager*locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *function_bg;
//添加一个标志，来控制“登陆成功”HUB只在初次进入登录页面显示
@property(nonatomic,assign) int flag;
@end
