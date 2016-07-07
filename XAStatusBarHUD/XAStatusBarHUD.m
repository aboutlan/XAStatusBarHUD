//
//  XAStatusBarHUD.m
//  XAStatusBarHUDExample
//
//  Created by XangAm on 16/7/5.
//  Copyright © 2016年 XingAm. All rights reserved.
//

#import "XAStatusBarHUD.h"

static XAStatusBarHUD *hud;
static UIColor *XAStatusBarHUDBackgroundColor;
static UIColor *XAStatusBarHUDForegroundColor;
static UIFont *XAStatusBarHUDFont;
static NSAttributedString *XAStatusBarHUDAttributeString;
static NSInteger XAStatusBarHUDEdgeInsets;
static CGFloat XAStatusBarHUDAnimDuration;
static NSInteger XAStatusBarHUDWidth;
static NSInteger XAStatusBarHUDHeight;
static NSTimeInterval XAStatusBarHUDStayTimer;
#define XA_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define XA_SCREEN_H [UIScreen mainScreen].bounds.size.height


@interface XAStatusBarHUD()

/**
 *  子控件titleBtn,用于显示标题内容和图片
 */
@property(nonatomic,strong)UIButton *titleBtn;
/**
 *  定时器
 */
@property(nonatomic,strong) NSTimer *timer;
/**
 *  自定义的View(默认自带的菊花控件)
 */
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;
/**
 *  自定义的View
 */
@property(nonatomic,strong)UIView *customView;
/**
 *  HUD是否已经显示
 */
@property(nonatomic,assign,getter=isShow)BOOL show;
/**
 *  HUD进入动画的动画是否完毕
 */
@property(nonatomic,assign,getter=isEnterAnimComplete)BOOL enterAnimComplete;
@end
@implementation XAStatusBarHUD
#pragma mark - lazy
- (UIButton *)titleBtn{
    
    if(!_titleBtn){
        
        //初始化titleBtn
        _titleBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.userInteractionEnabled = NO;
//        _titleBtn.backgroundColor = [UIColor greenColor];
        _titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, XAStatusBarHUDEdgeInsets);
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, XAStatusBarHUDEdgeInsets, 0, 0);
        _titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
        
    }
    
    return _titleBtn;
    
}

- (UIActivityIndicatorView *)loadingView{
    
    if(!_loadingView){
        
         _loadingView= [[UIActivityIndicatorView alloc]init];
     
         [_loadingView startAnimating];
    }
    
    return _loadingView;
   
}
#pragma mark - create
+ (instancetype)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //设置默认的值
        XAStatusBarHUDBackgroundColor = [UIColor blackColor];
        XAStatusBarHUDForegroundColor = [UIColor whiteColor];
        XAStatusBarHUDFont = [UIFont systemFontOfSize:14];
        XAStatusBarHUDEdgeInsets = 5;
        XAStatusBarHUDAnimDuration =0.25;
        XAStatusBarHUDHeight = 20;
        XAStatusBarHUDStayTimer = 2;
        XAStatusBarHUDWidth = XA_SCREEN_W;
        
        //初始化HUD的Frame
        hud = [[XAStatusBarHUD alloc]initWithFrame:CGRectMake(0, 0, XAStatusBarHUDWidth, 0)];
        hud.windowLevel  = UIWindowLevelAlert;
        
    });
    return hud;
}

#pragma mark - in
- (void)showWithTitle:(NSString *)title image:(UIImage *)image loading:(BOOL)isLoading customView:(UIView *)customView{
    if(hud.isShow){
        
        [hud noAnimHide];
    }

    //默认为隐藏状态
    hud.customView.hidden = YES;
    hud.customView = customView;
    
    //让timer无效
    [self.timer invalidate];
    self.timer = nil;
    
    //初始化hud及其子控件的内容
    hud.backgroundColor = XAStatusBarHUDBackgroundColor;
    hud.hidden = NO;
    hud.show = YES;
    
    //设置子控件内容
    [hud.titleBtn setTitle:title forState:UIControlStateNormal];
    [hud.titleBtn setImage:image forState:UIControlStateNormal];
    [hud.titleBtn setTitleColor:XAStatusBarHUDForegroundColor forState:UIControlStateNormal];
    hud.titleBtn.titleLabel.font = XAStatusBarHUDFont;
    //设置富文本
    [hud.titleBtn setAttributedTitle:XAStatusBarHUDAttributeString forState:UIControlStateNormal];

    
    //判断是否为长时间停留的HUD
    if (!isLoading) {
        //创建定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:XAStatusBarHUDStayTimer target:[XAStatusBarHUD class] selector:@selector(hide) userInfo:nil repeats:NO];
    }
    

    
    [UIView animateWithDuration:XAStatusBarHUDAnimDuration animations:^{
        CGRect frame  = hud.frame;
        frame.size.height = XAStatusBarHUDHeight;
        hud.frame = frame;
        hud.enterAnimComplete = NO;
        
    }completion:^(BOOL finished) {
        //表示进入动画已完成
        hud.enterAnimComplete = YES;
        
        //计算子控件titleBtn的Frame
        //按钮的宽度 = hud.宽度  按钮高度 = 按钮自适应的高度 + (内边距 * 2)
        [hud.titleBtn sizeToFit];
        CGFloat titleBtnW =hud.titleBtn.frame.size.width +(XAStatusBarHUDEdgeInsets *2);
        CGFloat titleBtnH = hud.frame.size.height;
        hud.titleBtn.bounds = CGRectMake(0, 0, titleBtnW, titleBtnH);
        hud.titleBtn.center  = hud.center;
        
        
        //计算子控件customView的Frame
        //customView的X = ((总宽 - 按钮的宽度) * 0.5) - customView自身的宽度
        [hud.customView sizeToFit];
        CGFloat customViewX = ((XA_SCREEN_W - hud.titleBtn.frame.size.width) * 0.5) - self.customView.frame.size.width;
        CGFloat customViewWidth =hud.customView.frame.size.width;
        hud.customView.frame = CGRectMake(customViewX, 0, customViewWidth, 20);
        hud.customView.hidden = NO;
        [hud addSubview:hud.customView];
        [hud addSubview:hud.titleBtn];
        

        //动画执行完毕之后加timer添加进主运行循环,开启timer
        if(self.timer != nil) [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
      
        
    }];
    
    
}

-(void)noAnimHide{
    
    //判断如果HUD已经显示或当前动画还没完毕或没有值,直接return
    
    [hud.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect frame  = hud.frame;
    frame.size.height -= XAStatusBarHUDHeight;
    hud.frame = frame;
        
    hud.hidden = YES;
    hud.show = NO;
   
}
#pragma mark - out
+(void)showInfoWithTitle:(NSString *)title image:(UIImage *)image{
    
    [self showInfoWithTitle:title image:image loading:NO];
    
}


+(void)showInfoWithTitle:(NSString *)title image:(UIImage *)image loading:(BOOL)isLoading{
    
    [[self share]showWithTitle:title image:image loading:isLoading customView:nil];

}

+ (void)showLoadingWithTitle:(NSString *)title image:(UIImage *)image{
    
    [self showCustomWithTitle:title image:image loading:YES customView:[[self share]loadingView]];
   
}

+ (void)showCustomWithTitle:(NSString *)title image:(UIImage *)image loading:(BOOL)isLoading customView:(UIView *)customView{

    [[self share]showWithTitle:title image:image loading:isLoading customView:customView];
   
}


+(void)hide{
    hud = [self share];
    //判断如果HUD已经显示或当前动画还没完毕或没有值,直接return
    if(![hud isShow]||!hud||![hud isEnterAnimComplete])return;
    
    [hud.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [UIView animateWithDuration:XAStatusBarHUDAnimDuration animations:^{
        CGRect frame  = hud.frame;
        frame.size.height -= XAStatusBarHUDHeight;
        hud.frame = frame;
        
    }completion:^(BOOL finished) {
        hud.hidden = YES;
        hud.show = NO;
    }];
   
  
}

+ (void)setBackgroundColor:(UIColor *)color{
    
    [[self share]setBackgroundColor:color];
    XAStatusBarHUDBackgroundColor = color;
}

+ (void)setTitleColor:(UIColor *)color{
    
    [[[self share]titleBtn] setTitleColor:color forState:UIControlStateNormal];
    XAStatusBarHUDForegroundColor = color;
}

+ (void)setFont:(UIFont *)font{

    [[self share]titleBtn].titleLabel.font = font;
    XAStatusBarHUDFont = font;
    
}

+ (void)setAttributedTitle:(NSAttributedString *)attributedStr{
    
    [[self share]titleBtn].titleLabel.attributedText = attributedStr;
    XAStatusBarHUDAttributeString = attributedStr;
    
}
+ (void)setStayTimer:(NSTimeInterval)stayTimer{
    

    XAStatusBarHUDStayTimer = stayTimer;
    
}

@end
