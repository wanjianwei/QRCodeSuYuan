//
//  AppConstants.h
//  Medical_Wisdom
//
//  Created by Mac on 14-2-28.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#ifndef Medical_Wisdom_AppConstants_h
#define Medical_Wisdom_AppConstants_h


#pragma mark Register TextField Tag enum
enum TAG_REGISTER_TEXTFIELD{
    
    Tag_EmailTextField  = 100,    //邮箱
    Tag_AccountTextField ,        //用户名
    Tag_TempPasswordTextField,    //登录密码
    Tag_ConfirmPasswordTextField, //确认登录密码
    Tag_RecommadTextField,        //推荐人
};

#pragma mark - Register Label Tag
#define Tag_SourceLabel            10086   //注册来源

#pragma mark - protocol Btn Tag 协议有关的btn的tag值
enum TAG_PROTOCOL_BUTTON{
    
    Tag_isReadButton = 200,   //是否已阅读
    Tag_servicesButton,       //服务协议
    Tag_privacyButton         //隐私协议
};

#endif
