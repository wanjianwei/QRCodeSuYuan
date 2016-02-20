//
//  PackageHeader.m
//  BusinessLogicLayer
//
//  Created by jway on 14-10-5.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "PackageHeader.h"

@implementation PackageHeader

-(PackageHeader*)init
{
    self=[super init];
    if (self)
    {
        memset(&header, 0, sizeof(header));
        now_time=0;
        place_lat=0.0;
        place_long=0.0;
        
    }
    return self;
}

//用户登录
-(NSMutableData*)packageHeader_Login
{
    NSMutableData*data;
    
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=(long long int)time;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=11;
    header.action_type=2;
    header.user_level=5;
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

//用户注册
-(NSMutableData *)packageHeader_Regaister
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=11;
    header.action_type=1;
    header.user_level=5;
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

//用户查询
-(NSMutableData*)packageHeader_Query
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=21;
    header.action_type=7;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    return data;
    
}

//用户查询，无经纬度
-(NSMutableData*)packageHeader_Query1
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=21;
    header.action_type=7;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;

}

//用户忘记密码
-(NSMutableData*)packageHeader_getPassword
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=11;
    header.action_type=6;
    header.user_level=5;
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

//提交验证码，完成注册
-(NSMutableData*)packageHeader_submitVerifyNum
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=60;
    header.action_type=8;
    header.user_level=5;
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}
//获取商品物流信息
-(NSMutableData*)packageHeader_logistics
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=21;
    header.action_type=3;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}
//获取用户基本信息（用户权限在登录后获得）
-(NSMutableData*)packageHeader_return_info
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=21;      //需要修改
    header.action_type=8;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;

    
}

//修改绑定电话
-(NSMutableData*)packageHeader_change_phoneNum
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=11;
    header.action_type=4;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;


}
//修改密码
-(NSMutableData*)packageHeader_change_password
{
    
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=11;
    header.action_type=5;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;

}

//查看所有用户评论
-(NSMutableData*)packageHeader_checkcomments
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=60;
    header.action_type=44;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

//发表评论
-(NSMutableData*)packageHeader_comment
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=60;
    header.action_type=38;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

//实现点赞功能
-(NSMutableData*)packageHeader_dianzhan
{
    NSMutableData*data;
    //首先取出时间，能后对其进行大小端转换
    double time=[[NSDate date] timeIntervalSince1970];
    now_time=[[NSNumber numberWithDouble:time] longLongValue]*1000;
    //long long型数据类型进行大小端转化
    int time_low=(int)now_time;
    int time_low1=htonl(time_low);
    long long now_time_temp=(long long)time_low1;
    now_time_temp=(now_time_temp<<32);
    int time_high=(int)(now_time>>32);
    int time_high1=htonl(time_high);
    now_time_temp+=time_high1;
    now_time=now_time_temp;
    header.package_type=60;
    header.action_type=40;
    //取出用户等级
    header.user_level=[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_level"] charValue];
    //取出服务器分配的用户名
    NSData*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    Byte*user_name=(Byte*)[name bytes];
    for (int i=0; i<8; i++)
    {
        header.user_name[i]=user_name[i];
    }
    //将数据包头部的大部分转化为字节流
    data=[[NSMutableData alloc] init];
    [data appendBytes:&header length:sizeof(header)];
    [data appendBytes:&now_time length:sizeof(now_time)];
    [data appendBytes:&place_lat length:sizeof(place_lat)];
    [data appendBytes:&place_long length:sizeof(place_long)];
    return data;
}

@end
