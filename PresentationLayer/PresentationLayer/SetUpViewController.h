//
//  SetUpViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-19.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAImageView.h"
#import "BusinessLogicLayer.h"
#import "UIButton+Bootstrap.h"
@interface SetUpViewController : UIViewController
//设置一个数组用来存放用户基本信息
@property(strong,nonatomic) NSArray*user_info;

@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *password;
@property (weak, nonatomic) IBOutlet UILabel *telNum;
@property (weak, nonatomic) IBOutlet UIImageView *setup_bg;

@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *customer_id;


@property (weak, nonatomic) IBOutlet UIButton *changePasswrd;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneNum;


- (IBAction)back:(id)sender;

- (IBAction)reserve:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)changePhoneNum:(id)sender;
@end
