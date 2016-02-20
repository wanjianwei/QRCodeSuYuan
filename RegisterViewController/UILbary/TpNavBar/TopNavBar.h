//
//  TopNavBar.h
//  XL_BabayOnline
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 ZCB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopNavBarDelegate;

@interface TopNavBar : UIView

@property (nonatomic,assign) id<TopNavBarDelegate> delegate;


- (id)initWithFrame:(CGRect)frame bgImageName:(NSString *)bgimgName labelTitle:(NSString *)title labFrame:(CGRect)labelFrame leftBool:(BOOL)haveLeftBtn leftBtnFrame:(CGRect)leftBtnFrm leftBtnImageName:(NSString *)LeftBtnImgName rightBool:(BOOL)haveRightBtn rightBtnFrame:(CGRect)rightBtnFrm rightBtnImageName:(NSString *)rightBtnImgName;

@end

@protocol TopNavBarDelegate <NSObject>

@optional
- (void)itemButtonClicked:(int)index;
@end
