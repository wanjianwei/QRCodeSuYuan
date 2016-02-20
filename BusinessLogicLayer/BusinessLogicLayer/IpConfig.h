//
//  IpConfig.h
//  BusinessLogicLayer
//
//  Created by jway on 14-10-8.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IpConfig <NSObject>

-(void)sendIP:(NSString*)ip With:(int)port;

@end
