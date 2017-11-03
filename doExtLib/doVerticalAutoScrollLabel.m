//
//  doAutoScrollLabel.m
//  Do_Test
//
//  Created by yz on 15/10/19.
//  CopyBottom © 2015年 DoExt. All Bottoms reserved.
//
#import "doVerticalAutoScrollLabel.h"
#import <CoreText/CoreText.h>

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1f)
#define doVerticalMarqueeLabelScrollType0GapTime 1.5 // type0 间隔时间 1.5秒

#ifndef ZJKeyPath
#define ZJKeyPath(object,attribute) @(((void)object.attribute,#attribute))
#endif
@interface doVerticalAutoScrollLabel()
@property (nonatomic, strong) NSMutableArray<NSString*> *contentArray;
@property (nonatomic, strong) UILabel *mainLab;
//@property (nonatomic, strong) UILabel *extraLabel; // scrollType = doVerticalMarqueeLabelScrollType0 实现效果的辅助label;
@property (nonatomic, assign) CGFloat curFontSize;
@property (nonatomic, strong) NSString *curFontStyle;
@property (nonatomic, strong) NSString *curFontFlag;
@property (nonatomic, strong) NSMutableDictionary *attributeDict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *currentTitle;
@property (nonatomic, assign) NSInteger currentTitleIndex;

@end
@implementation doVerticalAutoScrollLabel

- (instancetype)initWithFrame:(CGRect)frame withFontSize:(NSInteger)fontsize
{
    
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = true;
        _scrollType = doVerticalMarqueeLabelScrollType0;
        _scrollDuration = 2.0;
        _curFontSize = fontsize;
        //默认字体
        _curFontStyle = @"normal";
        _attributeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:fontsize],NSFontAttributeName,
                                           [UIColor blackColor],NSForegroundColorAttributeName,
                                           @(NSUnderlineStyleNone),NSUnderlineStyleAttributeName,nil];
        
        _mainLab = [[UILabel alloc] init];
        // 设置核心动画锚点
        _mainLab.layer.anchorPoint = CGPointMake(0, 0);
        _mainLab.numberOfLines = 0;
        _mainLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_mainLab];
        
        _currentTitleIndex = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startType1Animation) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

#pragma mark - private method

- (void)executeAnimationGroup {
    [_mainLab.layer removeAnimationForKey:@"doVerticalMarqueeLabelScrollType0"];
    // mainLabel初始位置Y值
    CGFloat mainLabelOriginalY = (self.frame.size.height - _mainLab.frame.size.height) / 2;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, mainLabelOriginalY)];
    NSValue *toValue1 = self.direction == doVerticalMarqueeLabelDirectionUp ? [NSValue valueWithCGPoint:CGPointMake(0, -_mainLab.frame.size.height)] : [NSValue valueWithCGPoint:CGPointMake(0, self.frame.size.height)];
    animation1.toValue = toValue1;
    animation1.beginTime = 0.0;
    animation1.duration = self.scrollDuration * 0.5;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    NSValue *fromValue2 = self.direction == doVerticalMarqueeLabelDirectionUp ? [NSValue valueWithCGPoint:CGPointMake(0, self.frame.size.height)] : [NSValue valueWithCGPoint:CGPointMake(0, -_mainLab.frame.size.height)];
    NSValue *toValue2 = [NSValue valueWithCGPoint:CGPointMake(0, mainLabelOriginalY)];
    animation2.fromValue = fromValue2;
    animation2.toValue = toValue2;
    animation2.beginTime = self.scrollDuration * 0.5;
    animation2.duration = self.scrollDuration * 0.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = self.scrollDuration;
    group.repeatCount = 0;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.animations = @[animation1, animation2];
    
    [_mainLab.layer addAnimation:group forKey:@"doVerticalMarqueeLabelScrollType0"];
    
    // 改变_mainLabel的text
    [self performSelector:@selector(changeMainLabelText) withObject:nil afterDelay:self.scrollDuration * 0.5];
}

- (void)changeMainLabelText {
    if (self.contentArray.count == 1) { // 不需要改变
        _currentTitle = self.contentArray[0];
    }else { // 更改mainLabel的内容
        _currentTitleIndex += 1;
        NSInteger realIndex = _currentTitleIndex % self.contentArray.count;
        _currentTitle = self.contentArray[realIndex];
        NSString *mainLabelText = _currentTitle;
        
        NSMutableAttributedString *mainLabelAttributeStr = [[NSMutableAttributedString alloc]initWithString:mainLabelText attributes:_attributeDict];
        
        [_mainLab setAttributedText:mainLabelAttributeStr];
        UILabel *tempLabel = [UILabel new];
        tempLabel.numberOfLines = 1;
        tempLabel.attributedText = _mainLab.attributedText;
        CGSize tempLabelSize = [tempLabel sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
        _mainLab.frame = CGRectMake(0, (self.frame.size.height - tempLabelSize.height) / 2, self.frame.size.width, tempLabelSize.height);
    }
}

- (void)resetTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.timer fire];
}


- (void)startType1Animation {
    if (self.scrollType == doVerticalMarqueeLabelScrollType1) {
        [_mainLab.layer removeAnimationForKey:@"doVerticalMarqueeLabelScrollType1"];
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        NSValue *fromValue = self.direction == doVerticalMarqueeLabelDirectionUp ? [NSValue valueWithCGPoint:CGPointMake(0, self.frame.size.height)] : [NSValue valueWithCGPoint:CGPointMake(0, -_mainLab.frame.size.height)];
        NSValue *toValue = self.direction == doVerticalMarqueeLabelDirectionUp ? [NSValue valueWithCGPoint:CGPointMake(0, -_mainLab.frame.size.height)] : [NSValue valueWithCGPoint:CGPointMake(0, self.frame.size.height)];
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        animation.repeatCount = CGFLOAT_MAX;
        animation.duration = self.scrollDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [_mainLab.layer addAnimation:animation forKey:@"doVerticalMarqueeLabelScrollType1"];
    }
}

- (void)startAnimation {
    if (_currentTitle == nil)return;
    switch (self.scrollType) {
        case doVerticalMarqueeLabelScrollType0: {
            [self resetTimer];
            break;
        }
        case doVerticalMarqueeLabelScrollType1: {
            [self startType1Animation];
            break;
        }
        default:
            break;
    }
}

#pragma -mark -set
-(void)setFontColor:(UIColor *)fontColor
{
    _attributeDict[NSForegroundColorAttributeName] = fontColor;
    if (_currentTitle) {
        [self changeText:_currentTitle];
    }
}
- (void)setFontSize:(CGFloat)fontSize
{
    _curFontSize = fontSize;
    UIFont *font;
    if([_curFontStyle isEqualToString:@"normal"])
    {
        [_attributeDict removeObjectForKey:NSObliquenessAttributeName];
        font = [UIFont systemFontOfSize:_curFontSize];
    }
    else if([_curFontStyle isEqualToString:@"bold"])
    {
        [_attributeDict removeObjectForKey:NSObliquenessAttributeName];
        font = [UIFont boldSystemFontOfSize:_curFontSize];
    }
    else if([_curFontStyle isEqualToString:@"italic"])
    {
        [_attributeDict setObject:@0.33 forKey:NSObliquenessAttributeName];
        
        font = [UIFont systemFontOfSize:_curFontSize];
    }
    else if([_curFontStyle isEqualToString:@"bold_italic"]){
        [_attributeDict setObject:@0.33 forKey:NSObliquenessAttributeName];
        font = [UIFont boldSystemFontOfSize:_curFontSize];
    }
    [_attributeDict setObject:font forKey:NSFontAttributeName];
    if (_curFontFlag) {
        [self setTextFlag:_curFontFlag];
    }
    if (_currentTitle) {
        [self changeText:_currentTitle];
    }
}
- (void)setFontStyle:(NSString *)fontStyle
{
    _curFontStyle = fontStyle;
    UIFont *font;
    if([fontStyle isEqualToString:@"normal"])
    {
        [_attributeDict removeObjectForKey:NSObliquenessAttributeName];
        font = [UIFont systemFontOfSize:_curFontSize];
    }
    else if([fontStyle isEqualToString:@"bold"])
    {
        [_attributeDict removeObjectForKey:NSObliquenessAttributeName];
        font = [UIFont boldSystemFontOfSize:_curFontSize];
    }
    else if([fontStyle isEqualToString:@"italic"])
    {
        [_attributeDict setObject:@0.33 forKey:NSObliquenessAttributeName];

        font = [UIFont systemFontOfSize:_curFontSize];
    }
    else if([fontStyle isEqualToString:@"bold_italic"]){
        [_attributeDict setObject:@0.33 forKey:NSObliquenessAttributeName];
        font = [UIFont boldSystemFontOfSize:_curFontSize];
    }
    [_attributeDict setObject:font forKey:NSFontAttributeName];
    if (_currentTitle) {
        [self changeText:_currentTitle];
    }

}

- (void)changeText:(NSString*)text {
    
    switch (_scrollType) {
        case doVerticalMarqueeLabelScrollType0: { // 中间停停一下继续滚动
            if (self.contentArray.count == 0)return;
            _currentTitle = self.contentArray[0];
            NSString *mainLabelText = _currentTitle;
            NSMutableAttributedString *mainLabelAttributeStr = [[NSMutableAttributedString alloc]initWithString:mainLabelText attributes:_attributeDict];
            
            [_mainLab setAttributedText:mainLabelAttributeStr];
            
            UILabel *tempLabel = [UILabel new];
            tempLabel.numberOfLines = 1;
            tempLabel.attributedText = _mainLab.attributedText;
            CGSize tempLabelSize = [tempLabel sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
            _mainLab.frame = CGRectMake(0, (self.frame.size.height - tempLabelSize.height) / 2, self.frame.size.width, tempLabelSize.height);
            
            break;
        }
        case doVerticalMarqueeLabelScrollType1: { // 匀速滚动
            _currentTitle = text;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:_attributeDict];
            if (attributeStr.length <= 0) {
                return;
            }
            [_mainLab setAttributedText:attributeStr];
            UILabel *tempLabel = [UILabel new];
            tempLabel.numberOfLines = 0;
            tempLabel.attributedText = _mainLab.attributedText;
            CGSize tempLabelSize = [tempLabel sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
            _mainLab.frame = CGRectMake(0, (self.frame.size.height - tempLabelSize.height) / 2, self.frame.size.width, tempLabelSize.height);

            break;
        }
        default:
            break;
    }
}

- (void)setContents:(NSArray *)contents
{
    [self.contentArray removeAllObjects];
    _currentTitleIndex = 0;
    self.contentArray = [contents mutableCopy];
    if (contents.count==0) {
        return;
    }
    NSMutableString *s = [NSMutableString string];
    if (contents.count == 1) {
        [s appendFormat:@"%@",contents[0]];
    }else {
        for (NSString *string in contents) {
            NSInteger stringIndex = [contents indexOfObject:string];
            if (stringIndex == contents.count - 1) {
                [s appendFormat:@"%@",string];
            }else {
                [s appendFormat:@"%@\n",string];
            }
        }
    }
    [self changeText:s];
}
- (void)setTextFlag:(NSString *)textFlag
{
    _curFontFlag = textFlag;
    if (IOS_7 && _curFontSize < 18) {
        return;
    }
    if ([textFlag isEqualToString:@"normal" ]) {
        _attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleNone);
        _attributeDict[NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleNone);
    }else if ([textFlag isEqualToString:@"underline" ]) {
        _attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    else if ([textFlag isEqualToString:@"strikethrough" ]) {
        [_attributeDict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    }
    if (_currentTitle) {
        [self changeText:_currentTitle];
    }
}
#pragma mark - lazy
- (NSMutableArray<NSString *> *)contentArray {
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
        return _contentArray;
    }
    return _contentArray;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:self.scrollDuration + doVerticalMarqueeLabelScrollType0GapTime target:self selector:@selector(executeAnimationGroup) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        return _timer;
    }
    return _timer;
}

#pragma mark - delloc/clear
- (void)clearSource {
    [_timer invalidate];
    _timer = nil;
    [_contentArray removeAllObjects];
    _currentTitleIndex = 0;
}
- (void)dealloc
{
    [self clearSource];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
