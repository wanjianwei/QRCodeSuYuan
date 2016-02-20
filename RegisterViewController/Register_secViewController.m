//
//  RegisterViewController.m
//  Login_Register
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import "Register_secViewController.h"
#import "TopNavBar.h"
#import "ViewController.h"
#import "CXAlertView.h"         //显示协议框

@interface Register_secViewController ()<UITableViewDataSource,UITableViewDelegate,TopNavBarDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BOOL          isRead;

@end

@implementation Register_secViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //创建导航条
  //  [self createCustomNavBar];
    //创建tableView
 //   [self createTableView];
    
    //在此页面供需监听3个通知，分别是1、服务器中途中断连接的通知“ConnectBreakDownNOtification”，2、网络中断连接的通知“networkbreakNotification”
    //3、返回注册信息的通知“return_dataNotification”
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakDown) name:@"ConnectBreakDownNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkBreak) name:@"networkbreakNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(return_data:) name:@"return_dataNotification" object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    //释放对象，减少内存占用
    //self.registerTableView=nil;
   // self.topNavBar=nil;
    
}

/**
 *	@brief	键盘出现
 *
 *	@param 	aNotification 	参数
 */
//防止键盘的出现会遮住输入框，但由于self..view不是scroll，不能用CGRectOffset方法

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil] ;

}

/**
 *	@brief	键盘消失
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建导航条
    [self createCustomNavBar];
    //创建tableView
    [self createTableView];
}


/**
 *	@brief	创建TableView
 */
- (void)createTableView
{

  //  _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, (FSystenVersion >= 7.0)?64.f:44.f, 320.f, (FSystenVersion >=7.0)?(ISIPHONE5?(568.f - 64.f):(480.f - 64.f)):(ISIPHONE5?(548.f - 44.f):(460.f - 44.f))) style:UITableViewStyleGrouped];
    
    _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 64.f, 375.f, 667-64) style:UITableViewStyleGrouped];
    
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.dataSource = self;
    [self.view addSubview:_registerTableView];
    
}

/**
 *	@brief	创建自定义导航条
 */
- (void)createCustomNavBar
{
    /*
    _topNavBar = [[TopNavBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, (FSystenVersion >= 7.0)?64.f:44.f)
                                      bgImageName:(FSystenVersion >= 7.0)?@"backgroundNavbar_ios7@2x":@"backgroundNavbar_ios6@2x"
                                       labelTitle:@"填写注册信息"
                                         labFrame:CGRectMake(90.f,(FSystenVersion >= 7.0)?27.f:7.f , 140.f, 30.f)
                                         leftBool:YES
                                     leftBtnFrame:CGRectMake(12.f, (FSystenVersion >= 7.0)?27.f:7.f, 30.f, 30.f)
                                 leftBtnImageName:@"button_back_bg@2x.png"
                                        rightBool:NO
                                    rightBtnFrame:CGRectZero
                                rightBtnImageName:nil];
    
    */
    _topNavBar = [[TopNavBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 375.f, 64)
                                      bgImageName:@"backgroundNavbar_ios7@2x"
                                       labelTitle:@"填写注册信息"
                                         labFrame:CGRectMake(110.f,27.f , 140.f, 30.f)
                                         leftBool:YES
                                     leftBtnFrame:CGRectMake(12.f, 27.0f, 30.f, 30.f)
                                 leftBtnImageName:@"button_back_bg@2x.png"
                                        rightBool:NO
                                    rightBtnFrame:CGRectZero
                                rightBtnImageName:nil];
    
    _topNavBar.delegate = self;
    [self.view addSubview:_topNavBar];
    
}

#pragma mark - TopNavBarDelegate Method
/**
 *	@brief	TopNavBarDelegate Method
 *
 *	@param 	index 	barItemButton 的索引值
 */

//点击返回按钮
- (void)itemButtonClicked:(int)index
{
    //插入点击返回按钮实现的功能
    //释放对象，减少内存占用
    self.registerTableView=nil;
     self.topNavBar=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    if (indexPath.section == 0){
        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 275.f, 21.f)];
        textField.tag = Tag_EmailTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"邮箱,必填";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        [cell addSubview:textField];
    
        
    }else if (indexPath.section == 1){
        
        cell.imageView.image = PNGIMAGE(@"register_user@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 275.f, 21.f)];
        textField.tag = Tag_AccountTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"用户名,必填";
        [cell addSubview:textField];
   
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 275.f, 21.f)];
            textField.tag = Tag_TempPasswordTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"密码,必填";
            [cell addSubview:textField];
  
            
        }else if (indexPath.row == 1){
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 275.f, 21.f)];
            textField.tag = Tag_ConfirmPasswordTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"确认密码，必填";
            [cell addSubview:textField];
       //     [textField release];
        }
        
    }else if (indexPath.section ==3){
        
        cell.imageView.image = PNGIMAGE(@"register_recommand_people@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 275.f, 21.f)];
        textField.tag = Tag_RecommadTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"真实姓名,(可选填)";
        [cell addSubview:textField];
     //   [textField release];
    }else if (indexPath.section == 4){
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // registerBtn.frame = CGRectMake((FSystenVersion >= 7.0)?0.f:10.f, 0.f, (FSystenVersion>=7.0)?320.f:300.f, 44.f);
        
        registerBtn.frame = CGRectMake(0.0f, 0.f, 375, 44.f);
        
        [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"register_btn@2x"] forState:UIControlStateNormal];
        [registerBtn setTitle:@"保存" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [cell addSubview:registerBtn];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        return nil;
    }else if (section == 1){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"注册后不可更改，3~20位字符，可包含英文、数字和“_”" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        
        return footerView;
    }else if (section == 2){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"密码为6位字符以上，可包含数字、字母（区分大小写）" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        return footerView;
    }else if (section == 3){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *isReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isReadBtn.frame = CGRectMake(10.f, 0.f, 21.f, 21.f);
        [isReadBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
        [isReadBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        isReadBtn.tag = Tag_isReadButton;
        [footerView addSubview:isReadBtn];
        
        UILabel *label1 = [Utils labelWithFrame:CGRectMake(35.f, 0.f, 70.f, 21.f) withTitle:@"我已阅读并同意" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label1];
        
        UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        servicesBtn.frame = CGRectMake(110.f, 0.f, 40.f, 21.f);
        [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        servicesBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [servicesBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        servicesBtn.tag = Tag_servicesButton;
        [footerView addSubview:servicesBtn];
                return footerView;
    }
    
    return nil;
}

#pragma mark - UIButtonClicked Method
//点击是否已阅读服务协议按钮
- (void)buttonClicked:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case Tag_isReadButton:
        {
            //是否阅读协议
            if (_isRead)
            {
                
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
                _isRead = NO;
            }
            else
            {
                
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
                _isRead = YES;
            }
        }
            
           break;
            //点击“服务协议”按钮，查看服务协议内容
        case Tag_servicesButton:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"服务协议" message:@"1、本软件的所有权和解释权归华中科技大学产品朔源和数据处理实验室所有。2、用户在注册之前，应当仔细阅读本协议，并同意遵守本协议后方可成为注册用户。一旦注册成功，则用户与朔源Lab之间自动形成协议关系，用户应当受本协议的约束。用户在使用特殊的服务或产品时，应当同意接受相关协议后方能使用。3、本协议可由所有者随时更新，用户应当及时关注并同意本站不承担通知义务。本站的通知、公告、声明或其它类似内容是本协议的一部分。4、本站承诺不主动对外公开或向第三方提供单个用户的注册资料及用户在使用网络服务时存储在本站的非公开内容。" cancelButtonTitle:nil];
            

            [alertView addButtonWithTitle:@"确定"
                                     type:CXAlertViewButtonTypeCancel
                                  handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                      // Dismiss alertview
                                      [alertView dismiss];
                                  }];
            [alertView show];

        }
            break;
    }
}

//表示图协议
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5.f;
    }
    else
    {
        return 21.f;
    }
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//保存用户填写信息
- (void)registerBtnClicked:(id)sender
{
    
    //先判断信息是否按要求填写完毕，之后才能决定是否进行注册
    
    if ([self checkValidityTextField])
    {
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        RegisterViewController*finishregister=[main instantiateViewControllerWithIdentifier:@"finishregisterview"];

        finishregister.customer_name=[(UITextField*)[self.view viewWithTag:Tag_AccountTextField] text];
        finishregister.customer_password=[(UITextField*)[self.view viewWithTag:Tag_TempPasswordTextField] text];
        finishregister.realname=[(UITextField*)[self.view viewWithTag:Tag_RecommadTextField] text];
        finishregister.customer_email=[(UITextField*)[self.view viewWithTag:Tag_EmailTextField] text];
        finishregister.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:finishregister animated:YES completion:nil];
    }
   
}

/**
 *	@brief	验证文本框是否为空
 */
#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    
    if ([(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"邮箱不能为空" delegate:self cancelBtn:@"确定" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户名不能为空" delegate:self cancelBtn:@"确定" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户密码不能为空" delegate:self cancelBtn:@"确定" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户确认密码不能为空" delegate:self cancelBtn:@"确定" otherBtnName:nil];
        
        return NO;
    }
    
    if (_isRead==NO)
    {
        [Utils alertTitle:@"提示" message:@"请确定是否同意服务协议" delegate:self cancelBtn:@"确定" otherBtnName:nil];
        return NO;
    }
    
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{     //当编辑推荐人（已改为真实姓名）时，键盘出现，此时需要避免键盘遮蔽编辑框
    
    if (textField.tag == Tag_RecommadTextField) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.view.frame = CGRectMake(0.f, -115.f, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:nil] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
            
        case Tag_EmailTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if (![Utils isValidateEmail:textField.text]) {
                    
                    [Utils alertTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_TempPasswordTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if ([[textField text] length] < 6) {
                    
                    [Utils alertTitle:@"提示" message:@"用户密码小于6位！" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_ConfirmPasswordTextField:    //验证密码
        {
            if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] !=0 && ([textField text]!= nil && [[textField text] length]!= 0))
            {
                
                if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[textField text]])
                {
                    [Utils alertTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_RecommadTextField:   //已经改为真实姓名
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.view.frame = CGRectMake(0.f, (FSystenVersion >= 7.0)?0.f:20.f, self.view.frame.size.width, self.view.frame.size.height);
                
            }completion:nil];
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //邮箱
    [[self.view viewWithTag:Tag_EmailTextField] resignFirstResponder];
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //确认密码
    [[self.view viewWithTag:Tag_ConfirmPasswordTextField] resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//通知响应方法
//未连接服务器
-(void)connectBreakDown
{
    UIAlertView*alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接中断，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}

//网络未连接
-(void)networkBreak
{
    UIAlertView*alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接中断，请重新连接网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}

//服务器返回注册信息
-(void)return_data:(NSNotification*)notification
{
    //取出通知中的传送数据
    NSDictionary*dic=[notification userInfo];
    NSString*content=[dic objectForKey:@"return_string"];
   //取出返回成功标志success_flag
    NSNumber*flag=[dic objectForKey:@"flag"];
    int flag1=[flag intValue];
    if (flag1==1)
    {
        UIStoryboard*main=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        RegisterViewController*registerview=[main instantiateViewControllerWithIdentifier:@"finishregisterview"];
        registerview.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:registerview animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Sorry!" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
@end
