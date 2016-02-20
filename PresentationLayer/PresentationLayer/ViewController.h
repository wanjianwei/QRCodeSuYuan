//
//  ViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import"Reachability.h"
#import "BusinessLogicLayer.h"
#import "PAImageView.h"          //圆形头像
#import "NSString+FontAwesome.h"  //自定义动态按钮
#import "UIButton+Bootstrap.h"
#import "Register_secViewController.h"
#import "LeafNotification.h"
@interface ViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL keyboardVisible;
}

//定义属性
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;
@property (weak, nonatomic) IBOutlet UILabel *passwordReturnInfo;
@property (weak, nonatomic) IBOutlet UIImageView *login_bg;

//定义方法
- (IBAction)server_link:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)getPassword:(id)sender;
- (IBAction)mingwenChang:(id)sender;
- (IBAction)register1:(id)sender;
@end
