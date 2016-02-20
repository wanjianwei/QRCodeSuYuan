//
//  LogisticsViewController.h
//  PresentationLayer
//
//  Created by jway on 14-10-17.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface LogisticsViewController : UIViewController<MKMapViewDelegate>
//用来存放上一个视图传送来的物流信息
@property(nonatomic,strong)NSArray*goods_logistics;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *goods_detail;

//物流详细信息展示label
@property (weak, nonatomic) IBOutlet UILabel *current_host;

@property (weak, nonatomic) IBOutlet UILabel *user_realname;

@property (weak, nonatomic) IBOutlet UILabel *user_phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *user_level;

@property (weak, nonatomic) IBOutlet UILabel *current_hostaction;

- (IBAction)back:(id)sender;

@end
