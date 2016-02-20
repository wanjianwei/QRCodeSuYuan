//
//  PackageHeader.h
//  BusinessLogicLayer
//
//  Created by jway on 14-10-5.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef unsigned char byte;
 struct packageheader
{
    byte package_type;
    byte action_type;
    byte return_flag;
    byte success_flag;
    byte package_tag;
    byte user_level;
    byte user_name[8];
    byte reserve[2];
};

@interface PackageHeader : NSObject

{
    struct packageheader header;
    long long int now_time;
    double place_lat;
    double place_long;
    
    
}
//经度和纬度不是每个数据包头部都需要，不需要时直接在此处赋值0，需要时在表示层赋值

//@property(nonatomic,assign) double place_long;
//@property(nonatomic,assign)double place_lat;
-(PackageHeader*)init;
//登录头部
-(NSMutableData*)packageHeader_Login;
//用户注册
-(NSMutableData*)packageHeader_Regaister;
//查询商品信息
-(NSMutableData*)packageHeader_Query;
//取回密码
-(NSMutableData*)packageHeader_getPassword;
//提交验证码
-(NSMutableData*)packageHeader_submitVerifyNum;
//查看物流信息
-(NSMutableData*)packageHeader_logistics;
//用户设置页面
-(NSMutableData*)packageHeader_return_info;
//更改密码
-(NSMutableData*)packageHeader_change_password;
//更改绑定电话
-(NSMutableData*)packageHeader_change_phoneNum;
//用户评论头部
-(NSMutableData*)packageHeader_comment;
//查看所有用户评论
-(NSMutableData*)packageHeader_checkcomments;
//这个是为了测试之用
-(NSMutableData*)packageHeader_Query1;
//实现点赞功能
-(NSMutableData*)packageHeader_dianzhan;
@end
