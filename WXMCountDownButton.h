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
- (void)startCountDown;
- (void)endCountDown;
@end

@interface WXMCountDownButton : UIButton
@property (nonatomic, assign) BOOL isCountDown;    /** 正在倒计时 */
@property (nonatomic, assign) NSInteger totalTime; /** 总时间 默认60 */
@property (nonatomic, assign) NSInteger speedTime; /** 每隔多久一次 默认1 */
@property (nonatomic, strong) UIColor *countDownColor; /** 倒计时颜色 */
@property (nonatomic, copy) NSString *formatString;    /** 默认 60 */
@property (nonatomic, assign) id<WXMCountDownDelegate> delegate;
@property (nonatomic, strong) void (^countDownBlock)(NSInteger currentTime);

/** 开始倒计时 */
- (void)startCountDown;
- (void)endCountDown;
@end
