//
//  doAutoScrollLabel.h
//  Do_Test
//
//  Created by yz on 15/10/19.
//  Copyright © 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,doVerticalMarqueeLabelDirection) // 滚动放下
{
    doVerticalMarqueeLabelDirectionUp = 0, // 向上滚动
    doVerticalMarqueeLabelDirectionDown = 1 // 向下滚动
};

typedef NS_ENUM(NSInteger,doVerticalMarqueeLabelScrollType) // 滚动方式
{
    doVerticalMarqueeLabelScrollType0 = 0, // 中间停一下继续滚动
    doVerticalMarqueeLabelScrollType1 = 1 // 匀速滚动
};

@interface doVerticalAutoScrollLabel : UIView
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,strong) NSString *fontStyle;
@property (nonatomic,strong) NSString *textFlag;
@property (nonatomic,assign) doVerticalMarqueeLabelDirection direction;
@property (nonatomic,assign) doVerticalMarqueeLabelScrollType scrollType; // 默认 doVerticalMarqueeLabelScrollType0
@property (nonatomic,strong) NSArray *contents;
@property (nonatomic, assign) NSTimeInterval scrollDuration;

- (instancetype)initWithFrame:(CGRect)frame withFontSize:(NSInteger)fontsize;

- (void)startAnimation; // 开始动画
@end
