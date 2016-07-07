//
//  XAStatusBarHUD.h
//  XAStatusBarHUDExample
//
//  Created by XangAm on 16/7/5.
//  Copyright © 2016年 XingAm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAStatusBarHUD : UIWindow

/**
 *  显示普通信息内容
 *
 *  @param title 显示的内容
 *  @param image 显示的图片
 */
+(void)showInfoWithTitle:(NSString *)title image:(UIImage *)image;
/**
 *  显示普通信息内容
 *
 *  @param title 显示的内容
 *  @param image 显示的图片
 *  @param loading 是否要保持HUD一直在显示的的状态
 */
+(void)showInfoWithTitle:(NSString *)title image:(UIImage *)image loading:(BOOL)isLoading;
/**
 *  显示带有UIActivityIndicatorView的信息内容。默认就是保持HUD一直在显示的状态
 *
 *  @param title 显示的内容
 *  @param image 显示的图片内容
 */
+(void)showLoadingWithTitle:(NSString *)title image:(UIImage *)image;
/**
 *  显示自定义内容
 *
 *  @param title 显示的内容
 *  @param image 显示的图片
 *  @param loading 是否要保持HUD一直在显示的状态
 *  @param customView 自定义左边的View
 */
+ (void)showCustomWithTitle:(NSString *)title image:(UIImage *)image loading:(BOOL)isLoading customView:(UIView *)customView;
/**
 *  隐藏StatusBarHUD
 */
+(void)hide;
/**
 *  设置HUD的背景色。默认值后:[UIColor blackColor]
 *
 *  @param color 背景颜色
 */
+(void)setBackgroundColor:(UIColor *)color;
/**
 *  设置文字的字体。默认值:[UIFont systemFontOfSize:14]
 *
 *  @param font 字体对象
 */
+(void)setFont:(UIFont *)font;
/**
 *  设置文字的颜色。默认值:[UIColor whiteColor]
 *
 *  @param color 文字颜色
 */
+(void)setTitleColor:(UIColor *)color;
/**
 *  设置文字的富文本内容。
 *
 *  @param color 富文本字符串对象
 */
+(void)setAttributedTitle:(NSAttributedString *)attributedStr;
/**
 *  设置HUD停留的时间
 *
 *  @param stayTimer 停留的时间
 */
+(void)setStayTimer:( NSTimeInterval)stayTimer;
@end
