//
//  BusinessLogicLayer.m
//  BusinessLogicLayer
//
//  Created by jway on 14-10-3.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "BusinessLogicLayer.h"
@implementation BusinessLogicLayer
static BusinessLogicLayer*shareManaged=nil;
BOOL isFirst=YES;
BOOL isconnect=NO;

Byte place_lat_endian[8];//存放经纬度大小端转换后的值
Byte place_long_endian[8];


NSMutableData*sendData;  //待发送的数据包头部

NSDictionary*toSend;

+(BusinessLogicLayer*)shareManaged
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManaged=[[self alloc] init];
    });
    
    return shareManaged;
}

//顾客注册
-(void)customer_Register:(NSString *)send
{
    //获得注册数据包头部数据
    PackageHeader*header=[[PackageHeader alloc] init];
    sendData=[header packageHeader_Regaister];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
    //链接服务器
   // socket1=[[AsyncSocket alloc] initWithDelegate:self];
   // [socket1 connectToHost:self.host onPort:self.port withTimeout:2 error:nil];
}

//顾客登陆
-(void)customer_Login:(NSString *)send
{
    //获得注册数据包头部数据
    PackageHeader*header=[[PackageHeader alloc] init];
    //将头部转为发送字节流
    sendData=[header packageHeader_Login];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
 //   [sendData appendBytes:&reserve length:sizeof(reserve)];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];

    NSLog(@"%@",sendData);
}

//忘记密码——获取密码
-(void)customer_GetPassword:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    sendData=[header packageHeader_getPassword];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //   [sendData appendBytes:&reserve length:sizeof(reserve)];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}

//提交验证码，完成注册
-(void)customer_submitVerifyNum:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    sendData=[header packageHeader_submitVerifyNum];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}

//顾客查询（要记录用户的经纬度，经纬度应该从表示层传来）
-(void)customer_Query:(NSString *)send WithLocation:(NSDictionary *)location
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // packageHeader_Query没有设定经纬度的值
    sendData=[header packageHeader_Query];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //解析出经纬度
    id lat_temp=[location objectForKey:@"latitude"];
    double place_lat=[lat_temp doubleValue];
    //对double数据place_lat进行大小端转换
    NSMutableData*lat_data=[[NSMutableData alloc] init];
    [lat_data appendBytes:&place_lat length:sizeof(place_lat)];
    Byte*lat_byte=(Byte*)[lat_data bytes];
    for (int i=0; i<=7; i++)
    {
        place_lat_endian[i]=lat_byte[7-i];
    }
    //取出纬度
    id long_temp=[location objectForKey:@"longtitude"];
    double place_long=[long_temp doubleValue];
    
    //对double型数据place_long进行大小端转换
    NSMutableData*long_data=[[NSMutableData alloc] init];
    [long_data appendBytes:&place_long length:sizeof(place_long)];
    Byte*long_byte=(Byte*)[long_data bytes];
    for (int i=0; i<=7; i++)
    {
        place_long_endian[i]=long_byte[7-i];
    }
   
    //在这里要附上经纬度信息（大小端也需要考虑）
    [sendData appendBytes:&place_lat_endian length:sizeof(place_lat_endian)];
    [sendData appendBytes:&place_long_endian length:sizeof(place_long_endian)];
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //   [sendData appendBytes:&reserve length:sizeof(reserve)];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}

//这个函数是为了测试
-(void)customer_Query:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // packageHeader_Query没有设定经纬度的值
    sendData=[header packageHeader_Query1];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //   [sendData appendBytes:&reserve length:sizeof(reserve)];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}


//查询商品物流信息
-(void)customer_logistics:(NSString *)send 
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_logistics];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];

}

//返回用户基本信息
-(void)customer_returnInfo:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_return_info];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];}

//用户修改密码
-(void)customer_changePassword:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_change_password];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}
//用户修改绑定电话
-(void)customer_changePhoneNum:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_change_phoneNum];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}


//用户评论
-(void)customer_comment:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_comment];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}

//查看用户评论
-(void)customer_checkcomments:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_checkcomments];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}

//用户点赞
-(void)customer_dianzhan:(NSString *)send
{
    PackageHeader*header=[[PackageHeader alloc] init];
    // 查询商品物流信息没有要求发送顾客所在地点
    sendData=[header packageHeader_dianzhan];
    //获得发送数据字段
    NSData*sendString=[send dataUsingEncoding:NSUTF8StringEncoding];
    //获得发送字段长度，并进行大小端转换
    int data_length=(int)sendString.length;
    data_length=htonl(data_length);
    //构建完整的发送数据包
    [sendData appendBytes:&data_length length:sizeof(data_length)];
    [sendData appendData:sendString];
    //直接向服务器发送登陆数据包
    [self.socket1 writeData:sendData withTimeout:-1 tag:0];
}


//网络连接页面连接服务器方法
-(void)connectWithIp:(NSString *)ip AndPort:(int)port
{

    self.socket1=[[AsyncSocket alloc] initWithDelegate:self];//这一步会使得连接断开
    [self.socket1 connectToHost:ip onPort:port withTimeout:-1 error:nil];
    
    [self performSelector:@selector(connectFailed) withObject:nil afterDelay:1.0f];
    
    
 }

-(void)connectFailed
{
    if (self.socket1.isConnected==NO)
    {
        [self.socket1 setDelegate:nil];
        [self.socket1 disconnect];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectFailedNotification" object:nil];
    }
    
}


// AsyncSocketDelegate 协议
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //向网络连接页面传送连接成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectSucessNotification" object:nil];
}

-(void)onsockDidDisconnect:(AsyncSocket*)sock;
{
    //注册中途与服务器断开连接通知，这个通知在“网络连接”页面不要监听
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectBreakDownNotification" object:sock];
}

//但向服务器发送数据完成时，调用此方法
-(void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取服务器传送过来的数据
    [self.socket1 readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //指定读取字段的长度,该部分字段为send str，包含服务器返回的注册状态信息
    NSData*strData=[data subdataWithRange:NSMakeRange(44, data.length-44)];
    //取出数据包中得用户名user_name
    NSData*user_name=[data subdataWithRange:NSMakeRange(6,8)];
    //从数据流中读取sucess_flag用来判断注册成功或失败,其中先将data转化为byte字节数组
    Byte*testbyte=(Byte*)[data bytes];
    int flag=(int)testbyte[3];   //取出数据包头部字节success_flag;
    Byte level=testbyte[5]; //取出数据包头部的用户等级
    NSNumber*user_level=[NSNumber numberWithChar:level];//包装成对象类型
    NSNumber*success_flag=[NSNumber numberWithInt:flag];//包装成对象类型
    //将从服务器读取的字节流转化为字符串
    NSString*content=[[NSMutableString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    //将转化好的字符串放进字典类型数据中，以便于广播通知投送
    toSend=[NSDictionary dictionaryWithObjectsAndKeys:content,@"return_string",success_flag,@"flag",nil];
    //将用户权限及用户名取出来，发送通知送出去
    NSDictionary*tosend2=[NSDictionary dictionaryWithObjectsAndKeys:user_level,@"user_level",user_name,@"user_name", nil];
    //注册投送通知，将用户登录后服务器分配的用户名和等级发送出去（只在登录页面接收）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"return_name&level" object:sock userInfo:tosend2];
    //注册投送服务器返回数据通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"return_dataNotification" object:sock userInfo:toSend];
    //为找回密码单独投送一个通知，因为找回密码功能与登录在一个页面，所以不能接受同一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"return_passwordNotification" object:sock userInfo:toSend];
}

@end
