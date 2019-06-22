//
//  CountDownButton.m
//  类库
//
//  Created by Mac on 17/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WXMCountDownButton.h"
@interface WXMCountDownButton ()
/** 当前数字 */
@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, strong) dispatch_source_t countDownTimer;
@property (nonatomic, strong) UIColor *oldColor;
@property (nonatomic, copy) NSString *oldTitle;
@end

@implementation WXMCountDownButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentTime = 60.0;
        _totalTime = 60.0;
        _speedTime = 1.0;
        _isCountDown = NO;

        _oldTitle = @"重新发送";
        _oldColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(startCountDown)]) {
        [self.delegate startCountDown]; return;
    } else {
       [self startCountDown];
    }
}

/* 开始 */
- (void)startCountDown {
    if (_isCountDown) return;
    
    _currentTime = _totalTime;
    if (_countDownTimer) {
        dispatch_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
    dispatch_resume(self.countDownTimer);
    NSLog(@"开始倒计时");
}

/* 结束 */
- (void)endCountDown {
    _isCountDown = NO;
    if (_countDownTimer) {
        dispatch_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
    self.userInteractionEnabled = YES;
    [self setTitle:_oldTitle forState:UIControlStateNormal];
    [self setTitleColor:_oldColor forState:UIControlStateNormal];
}

/* 倒计时 */
- (void)countDown {

    _isCountDown = YES;
    _currentTime--;
    self.userInteractionEnabled = NO;
    self.enabled = YES;
    
    if (_currentTime <= 0) {
        [self endCountDown];
        if (self.delegate && [self.delegate respondsToSelector:@selector(endCountDown)]) {
            [self.delegate endCountDown];
        }
    }
    
    if (_currentTime > 0) {
        if (self.countDownBlock) self.countDownBlock(self.currentTime);
        NSString *current = @(_currentTime).stringValue;
        NSString *title = [NSString stringWithFormat:_formatString ?: @"%@",current];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:_countDownColor forState:UIControlStateNormal];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(countDownWithcurrentTime:)]) {
            [self.delegate countDownWithcurrentTime:self.currentTime];
        }
    }
}

/* 总时间 */
- (void)setTotalTime:(NSInteger)totalTime {
    if (_isCountDown) return;
    _totalTime = totalTime;
    _currentTime = totalTime;
}

/* 速度 */
- (void)setSpeedTime:(NSInteger)speedTime {
    if (_isCountDown) return;
    _speedTime = speedTime;
}

/* 原标题 */
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if (state == UIControlStateNormal && !_isCountDown) _oldTitle = title;
    [super setTitle:title forState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    if (state == UIControlStateNormal && !_isCountDown) _oldColor = color;
    [super setTitleColor:color forState:state];
}

/* 定时器 */
- (dispatch_source_t)countDownTimer {
    if (!_countDownTimer) {
        __weak __typeof(self) weakself = self;
        dispatch_queue_t queue = dispatch_get_main_queue();
        _countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_countDownTimer,
                                  dispatch_walltime(NULL, 0),
                                  _speedTime * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_countDownTimer, ^{
            [weakself countDown];
        });
    }
    return _countDownTimer;
}

- (void)didMoveToSuperview {
    if (self.superview == nil) [self endCountDown];
}

- (void)dealloc {
    [self endCountDown];
}
@end
