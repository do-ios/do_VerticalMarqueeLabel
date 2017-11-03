//
//  do_VerticalMarqueeLabel_UI.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_VerticalMarqueeLabel_IView <NSObject>

@required
//属性方法
- (void)change_direction:(NSString *)newValue;
- (void)change_fontColor:(NSString *)newValue;
- (void)change_fontSize:(NSString *)newValue;
- (void)change_fontStyle:(NSString *)newValue;
- (void)change_text:(NSString *)newValue;
- (void)change_textFlag:(NSString *)newValue;
- (void)change_style:(NSString *)newValue;
- (void)change_duration:(NSString*)newValue;
//同步或异步方法


@end
