//
//  RegisterViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-4.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "NSString+FontAwesome.h"
#import "UIButton+Bootstrap.h"
#import "BusinessLogicLayer.h"
//#import "UIWindow+YzdHUD.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyNum;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
- (IBAction)nextStep:(id)sender;        //完成注册按钮
- (IBAction)sendNum:(id)sender;  //发送电话号码
- (IBAction)back:(id)sender; //返回按钮
@property (weak, nonatomic) IBOutlet UIImageView *register_bg;

//接收上一个注册模块填写的注册信息
@property(nonatomic,strong) NSString*customer_name;
@property(nonatomic,strong)NSString*customer_password;
@property(nonatomic,strong)NSString*realname;
@property(nonatomic,strong)NSString*customer_email;
@end
