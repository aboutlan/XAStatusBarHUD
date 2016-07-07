//
//  XAMainViewController.m
//  XAStatusBarHUDExample
//
//  Created by XangAm on 16/7/5.
//  Copyright © 2016年 XingAm. All rights reserved.
//

#import "XAMainViewController.h"
#import "XAStatusBarHUD.h"
typedef enum {
    
    XAStatusBarHUDTypeInfo ,
    XAStatusBarHUDTypeLoading,
    XAStatusBarHUDTypeCustom,
    XAStatusBarHUDTypeContinuousMsg,
    XAStatusBarHUDTypeHide
    
}XAStatusBarHUDType;

@interface XAMainViewController ()
@property(nonatomic,strong)NSArray *content;
@end

/**  Cell的标识  */
static NSString *const XACellIdentifier = @"cell";
@implementation XAMainViewController
- (NSArray *)content{
    if(_content ==nil){
        
        _content = @[@"显示普通信息",@"显示正在加载信息",@"自定义信息",@"连续消息",@"隐藏"];
    }
    return _content;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //初始化信息
    [self setup];
    //初始化HUD
    [self setupHUD];
}
#pragma mark - init
- (void)setup{
    
    //注册Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XACellIdentifier];
    self.tableView.rowHeight = 60;
    self.navigationItem.title = @"XAStatusBarHUDExample";
    
}
- (void)setupHUD{
    
    [XAStatusBarHUD setFont:[UIFont boldSystemFontOfSize:14]];
    [XAStatusBarHUD setTitleColor:[UIColor whiteColor]];
    [XAStatusBarHUD setBackgroundColor:[UIColor grayColor]];
    [XAStatusBarHUD setStayTimer:2];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.content.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XACellIdentifier];
    cell.textLabel.text = self.content[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
    
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == XAStatusBarHUDTypeInfo){
        
        [XAStatusBarHUD showInfoWithTitle:@"Normal" image:[UIImage imageNamed:@"cat"] loading:NO];
    }else if(indexPath.row ==XAStatusBarHUDTypeLoading){
        
        [XAStatusBarHUD showLoadingWithTitle:@"Loading" image:[UIImage imageNamed:@"cat"] ];
        
        
    }else if(indexPath.row == XAStatusBarHUDTypeCustom){
        //自定义控件
        UILabel *label = [[UILabel alloc]init];
        label.text = @"hello,CustomView!";
        label.font =[UIFont systemFontOfSize:14];
        label.textColor  =[UIColor redColor];
        
        [XAStatusBarHUD showCustomWithTitle:@"Custom" image:[UIImage imageNamed:@"check_1139091_easyicon.net"] loading:NO customView:label];
        
    }else if (indexPath.row == XAStatusBarHUDTypeContinuousMsg){
        
        NSMutableString *title = [NSMutableString stringWithString:@"hello,"];
        for(int i= 0 ;i <5;i++){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [title appendString:[NSString stringWithFormat:@"%i",i + 1]];
                [XAStatusBarHUD showInfoWithTitle:title image:nil loading:NO];
            });
            
        }
        
    }else{
        
        [XAStatusBarHUD hide ];
    }
    
    
 
}



@end
