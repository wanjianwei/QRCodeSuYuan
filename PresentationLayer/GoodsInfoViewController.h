//
//  GoodsInfoViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-16.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"
#import "Star.h"
#import "BusinessLogicLayer.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "DXAlertView.h"
@interface GoodsInfoViewController : UIViewController<UIAlertViewDelegate>

//商品数据存储数组
@property(nonatomic,strong)NSArray*array_info;

//用来存放解析二维码得到的字段，作为查询商品物流信息的发送字段
@property(nonatomic,strong)NSString*QRsendString;

- (IBAction)back:(id)sender;

- (IBAction)logistics:(id)sender;
- (IBAction)phoneNum:(id)sender;
- (IBAction)checkcomments:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *logistics_button;
@property (weak, nonatomic) IBOutlet UIScrollView *basic_info;
@property (weak, nonatomic) IBOutlet UIImageView *goods_display;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_score;
@property (weak, nonatomic) IBOutlet UILabel *goods_evaluate;
@property (weak, nonatomic) IBOutlet UILabel *goods_index;
@property (weak, nonatomic) IBOutlet UIButton *phoneNum;


//定义一个属性字符串，用来存储视频网址
@property(nonatomic,strong)NSString*vedioPath;

//在定义一个MPmediaPlayer播放器
@property(nonatomic,strong)MPMoviePlayerViewController*moviePlayer;
@end
