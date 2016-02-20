//
//  CommentViewController.h
//  PresentationLayer
//
//  Created by jway on 14-11-4.
//  Copyright (c) 2014年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *comment_list;

@property (weak, nonatomic) IBOutlet UITextField *comment_input;
//评论操作
- (IBAction)comment:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *comment_pty;

//返回操作
- (IBAction)back:(id)sender;

@property(retain,nonatomic)NSArray*Allcomment;

@end
