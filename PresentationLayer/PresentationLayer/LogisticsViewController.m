//
//  LogisticsViewController.m
//  PresentationLayer
//
//  Created by jway on 14-10-17.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import "LogisticsViewController.h"
@interface LogisticsViewController ()

@end

@implementation LogisticsViewController

//定义一个数组，用来存放各个城市的经纬度
CLLocationCoordinate2D location[6];
MKPolyline*line;//地图绘制直线
int count;//返回物流信息中城市的个数
int i;  //表示第i个锚点


//滑动视图的标签控件定义
//UILabel*label_1,*label_2,*label_3,*label_4,*label_5;
//UILabel*label1,*label2,*label3,*label4,*label5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
  //设置地图显示风格
    self.mapView.mapType=MKMapTypeStandard;
    //设置地图可缩放
    self.mapView.zoomEnabled=YES;
    //设置地图可以滑动
    self.mapView.scrollEnabled=YES;
    //设置滚动视图的属性
 //   self.goods_detail.frame=CGRectMake(0, 337, 320, 143);
//    self.goods_detail.contentSize=CGSizeMake(320, 300);
    self.goods_detail.hidden=YES;
    //城市个数
    count=(int)self.goods_logistics.count/10;
    //指定委托对象
    self.mapView.delegate=self;
    //在地图上创建锚点
    for (i=0; i<count; i++)
    {
        //创建一个锚点实例
        MKPointAnnotation*animation=[[MKPointAnnotation alloc] init];
        //取出每个城市的坐标
        CLLocationCoordinate2D coordinate={[[self.goods_logistics objectAtIndex:10*i+3] doubleValue],[[self.goods_logistics objectAtIndex:10*i+2] doubleValue]};
        
        //将每个城市的经纬度存入数组，绘制连接各城市的直线需要各城市的经纬度
        location[i]=coordinate;
        
        animation.coordinate=coordinate;
        animation.subtitle=[NSString stringWithFormat:@"地点：%@；状态：%@",[self.goods_logistics objectAtIndex:10*i+1],[self.goods_logistics objectAtIndex:10*i]];
        animation.title=[NSString stringWithFormat:@"时间：%@",[self.goods_logistics objectAtIndex:10*i+4]];
        [self.mapView addAnnotation:animation];
    }
    
    //绘制直线
    line=[MKPolyline polylineWithCoordinates:location count:count];
    [self.mapView addOverlay:line level:MKOverlayLevelAboveLabels];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    //释放对象，节约内存
    //置为nil，防止运行内存过大
    self.mapView=nil;
    self.goods_detail=nil;
    self.goods_logistics=nil;
    self.current_host=nil;
    self.user_level=nil;
    self.user_phoneNum=nil;
    self.user_realname=nil;
    self.current_hostaction=nil;
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    //清除缓存
    NSError*error=nil;
    NSString*tempPath=NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//MKMapViewDelegate协议中的方法，该方法返回值可用于定制锚点控件的外观

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString*identifier=@"animation";
    //获取可重用的锚点控件
    MKAnnotationView*annoView=[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView)
    {
    annoView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
        //设置该锚点控件是否可以显示气泡
        annoView.canShowCallout=YES;
      //给气泡视图右边按钮定义一个UIcontrol事件
     annoView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
     annoView.image=[UIImage imageNamed:@"pos.gif"];
        return annoView;
    
}

//MKMapViewDelegate协议中的方法,点击右边按钮会触发响应，将物流基本信息填在scrollView中
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.goods_detail.hidden=NO;
     MKPointAnnotation*myannotation=(MKPointAnnotation*)view.annotation;
    //判断是哪个锚点被点击触发，以决定显示的内容
    if (myannotation.coordinate.latitude==location[0].latitude)
    {
        
        self.current_host.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:5]];
        self.user_realname.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:6]];
        self.user_phoneNum.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:7]];
        self.user_level.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:8]];
        self.current_hostaction.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:9]];
    }
    
    
    else if (myannotation.coordinate.latitude==location[1].latitude)
    {
        
        self.current_host.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:15]];
        self.user_realname.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:16]];
        self.user_phoneNum.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:17]];
        self.user_level.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:18]];
        self.current_hostaction.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:19]];
    }
    
    else if (myannotation.coordinate.latitude==location[2].latitude)
    {
        self.current_host.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:25]];
        self.user_realname.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:26]];
        self.user_phoneNum.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:27]];
        self.user_level.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:28]];
        self.current_hostaction.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:29]];
    }
    
    else if (myannotation.coordinate.latitude==location[3].latitude)
    {
        self.current_host.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:35]];
        self.user_realname.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:36]];
        self.user_phoneNum.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:37]];
        self.user_level.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:38]];
        self.current_hostaction.text=[NSString stringWithFormat:@"%@",[self.goods_logistics objectAtIndex:39]];
    }
}

//代理方法MKPolyLine
-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolyline*polyline=(MKPolyline*)overlay;
    MKPolylineRenderer*render=[[MKPolylineRenderer alloc] initWithPolyline:polyline];
    render.lineWidth=4.0;
    render.strokeColor=[UIColor redColor];
    render.fillColor=[UIColor redColor];
    return render;
}
 
@end
