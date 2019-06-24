//
//  CountDownButton.h
//  类库
//
//  Created by Mac on 17/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WXMCountDownDelegate <NSObject>
@optional
- (void)countDownWithcurrentTime:(NSInteger)currentTime;
- (BOOL)startCountDown;
- (void)endCountDown;
@end

@interface WXMCountDownButton : UIButton
/** 正在倒计时 */
@property (nonatomic, assign) BOOL isCountDown;
/** 总时间 默认60 */
@property (nonatomic, assign) NSInteger totalTime;
 /** 每隔多久一次 默认1 */
@property (nonatomic, assign) NSInteger speedTime;
 /** 倒计时颜色 */
@property (nonatomic, strong) UIColor *countDownColor;
 /** 默认 60 */
@property (nonatomic, copy) NSString *formatString;
@property (nonatomic, assign) id<WXMCountDownDelegate> delegate;
@property (nonatomic, strong) void (^countDownBlock)(NSInteger currentTime);

/** 开始倒计时 */
- (void)startCountDown;
- (void)endCountDown;
@end
