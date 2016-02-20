//
//  TopNavBar.m
//  XL_BabayOnline
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 ZCB. All rights reserved.
//

#import "TopNavBar.h"

@interface TopNavBar ()


@property (nonatomic,assign) CGRect   backgroundImageViewFrame;
@property (nonatomic,strong) NSString *backgroundImageName;

@property (nonatomic,strong) NSString *labelTitleStr;
@property (nonatomic,assign) CGRect    labelFrm;

@property (nonatomic,assign) BOOL      haveLftBtn;
@property (nonatomic,assign) CGRect    lftBtnFrm;
@property (nonatomic,strong) NSString  *lftBtnImgName;

@property (nonatomic,assign) BOOL       haveRhtBtn;
@property (nonatomic,assign) CGRect     rhtBtnFrm;
@property (nonatomic,strong) NSString   *rhtBtnImgName;


@end

@implementation TopNavBar

@synthesize backgroundImageViewFrame = _backgroundImageViewFrame;
@synthesize backgroundImageName      = _backgroundImageName;

@synthesize labelTitleStr            = _labelTitleStr;
@synthesize labelFrm                 = _labelFrm;

@synthesize haveLftBtn               = _haveLftBtn;
@synthesize lftBtnFrm                = _lftBtnFrm;
@synthesize lftBtnImgName            = _lftBtnImgName;

@synthesize haveRhtBtn               = _haveRhtBtn;
@synthesize rhtBtnFrm                = _rhtBtnFrm;
@synthesize rhtBtnImgName            = _rhtBtnImgName;


- (id)initWithFrame:(CGRect)frame bgImageName:(NSString *)bgimgName labelTitle:(NSString *)title labFrame:(CGRect)labelFrame leftBool:(BOOL)haveLeftBtn leftBtnFrame:(CGRect)leftBtnFrm leftBtnImageName:(NSString *)LeftBtnImgName rightBool:(BOOL)haveRightBtn rightBtnFrame:(CGRect)rightBtnFrm rightBtnImageName:(NSString *)rightBtnImgName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundImageViewFrame = frame;
        self.backgroundImageName      = bgimgName;
        
        self.labelTitleStr            = title;
        self.labelFrm                 = labelFrame;
        
        self.haveLftBtn               = haveLeftBtn;
        self.lftBtnFrm                = leftBtnFrm;
        self.lftBtnImgName            = LeftBtnImgName;
        
        self.haveRhtBtn               = haveRightBtn;
        self.rhtBtnFrm                = rightBtnFrm;
        self.rhtBtnImgName            = rightBtnImgName;
        
        //创建背景图片
        [self createBackgroundImageView];
        
        //创建label标题
        [self createTitleLabel];
        
        //创建barButtonItem
        [self createBarButtonItem];
        
    }
    return self;
}

/**
 *	@brief	创建背景图片
 */
- (void)createBackgroundImageView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.backgroundImageViewFrame];
    bgImageView.image = [UIImage imageNamed:self.backgroundImageName];
    [self addSubview:bgImageView];
   // [bgImageView release];
}

/**
 *	@brief	创建Label标题
 */
- (void)createTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.labelFrm];
    label.text = self.labelTitleStr;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.f];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
   // [label release];
    
}

/**
 *	@brief	创建barButtonItem
 */
- (void)createBarButtonItem
{
    
    if (self.haveLftBtn) {
        //创建左侧的按钮
        UIButton *LeftClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        LeftClickBtn.frame = self.lftBtnFrm;
        [LeftClickBtn setImage:[UIImage imageNamed:self.lftBtnImgName] forState:UIControlStateNormal];
        [LeftClickBtn setTag:10010];
        [LeftClickBtn addTarget:self action:@selector(navBarBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:LeftClickBtn];
    }
    
    if (self.haveRhtBtn) {
        
        //创建右侧的按钮
        UIButton *rightClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightClickBtn.frame = self.rhtBtnFrm;
        [rightClickBtn setImage:[UIImage imageNamed:self.rhtBtnImgName] forState:UIControlStateNormal];
        [rightClickBtn setTag:10011];
        [rightClickBtn addTarget:self action:@selector(navBarBtnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightClickBtn];
    }
    
}

/**
 *	@brief	按钮的点击事件
 *
 *	@param 	sender 	传递的参数
 */
- (void)navBarBtnItemClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 10010:
        {
            if ([self.delegate respondsToSelector:@selector(itemButtonClicked:)]) {
                
                [self.delegate itemButtonClicked:0];
            }
        }
            break;
        case 10011:
        {
            if ([self.delegate respondsToSelector:@selector(itemButtonClicked:)]) {
                
                [self.delegate itemButtonClicked:1];
            }
        }
            break;
            
        default:
            break;
    }
    
}


@end
