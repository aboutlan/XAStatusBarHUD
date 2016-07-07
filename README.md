# XAStatusBarHUD
An simple and easy to use cover statusbar HUD


#Demo Project
![2.gif](https://ooo.0o0.ooo/2016/07/07/577de6fde7f84.gif)
![4.gif](https://ooo.0o0.ooo/2016/07/07/577de6fe28821.gif)

#Installation

##Manual import：
- Add the `XAStatusBarHUD` folder to your Xcode project.
- Import the header file：#import `"XAStatusBarHUD.h"`

##ShowInfoMessage
```objc
 [XAStatusBarHUD showInfoWithTitle:@"Normal" image:nil];
```
##ShowLoadingMessage
- HUD Keep always show

```objc
 [XAStatusBarHUD showLoadingWithTitle:@"Loading" image:nil];
```

##CustomHUD

- setupHUD

```objc
[XAStatusBarHUD setFont:[UIFont boldSystemFontOfSize:14]];
[XAStatusBarHUD setTitleColor:[UIColor whiteColor]];
[XAStatusBarHUD setBackgroundColor:[UIColor grayColor]];
[]XAStatusBarHUD setStayTimer:2];
```

- custormMessage

```objc
//自定义控件
UILabel *label = [[UILabel alloc]init];
label.text = @"hello,CustomView!";
label.font =[UIFont systemFontOfSize:14];
label.textColor  =[UIColor redColor];

[XAStatusBarHUD showCustomWithTitle:@"Custom" image:[UIImage imageNamed:@"check_1139091_easyicon.net"] loading:NO customView:label];
```
