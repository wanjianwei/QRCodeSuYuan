//
//  BusinessLogicLayer.h
//  BusinessLogicLayer
//
//  Created by jway on 14-10-3.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "PackageHeader.h"
@interface BusinessLogicLayer : NSObject<AsyncSocketDelegate>
@property(nonatomic,strong)NSString*host;
@property(nonatomic,assign)int port;
   //判断是否为第一次连接
@property(nonatomic,strong)AsyncSocket*socket1;
+(BusinessLogicLayer*)shareManaged;
-(void)customer_Login:(NSString*)send;
-(void)customer_Register:(NSString*)send;
-(void)connectWithIp:(NSString*)ip AndPort:(int)port;
-(void)customer_GetPassword:(NSString *)send;
-(void)customer_submitVerifyNum:(NSString *)send;
-(void)customer_Query:(NSString *)send WithLocation:(NSDictionary*)location;
-(void)customer_logistics:(NSString *)send;//获取商品物流信息
-(void)customer_returnInfo:(NSString *)send;//返回用户注册信息
-(void)customer_changePhoneNum:(NSString *)send;//修改绑定电话
-(void)customer_changePassword:(NSString *)send;//修改密码

//用户评论
-(void)customer_comment:(NSString *)send;
//查看用户评论
-(void)customer_checkcomments:(NSString *)send;

//用户点赞
-(void)customer_dianzhan:(NSString *)send;

//测试之用
-(void)customer_Query:(NSString *)send;
@end
