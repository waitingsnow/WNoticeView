//
//  WNoticeView.m
//  WNoticeView
//
//  Created by snow on 15/9/8.
//  Copyright (c) 2015年 yojianzhi. All rights reserved.
//

#import "WNoticeView.h"
#import "AppDelegate.h"

// 动态获取屏幕宽高
#define WScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WScreenWidth ([UIScreen mainScreen].bounds.size.width)
// application
#define WApplication [UIApplication sharedApplication]
// appDelegate
#define WAppDelegate ((AppDelegate *)WApplication.delegate)

// 弹出框动画时间
#define WAnimationTime 0.25f
// 提示框弹出时间
#define WAlertViewPopTime 0.15f
// 提示框显示时间
#define WAlertViewShowTime 2.5f
// 圆角
#define WCornerRadius 4.0f

static WNoticeView *_sharedNoticeView = nil;

@interface WNoticeView ()
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation WNoticeView

+ (instancetype)sharedNoticeView{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedNoticeView = [[super allocWithZone:NULL] initWithFrame:CGRectMake(WScreenWidth / 4, WScreenHeight / 3 * 2, WScreenWidth / 2, 40)];
		_sharedNoticeView.center = CGPointMake(WScreenWidth / 2, WScreenHeight / 3);
		_sharedNoticeView.font = [UIFont systemFontOfSize:13];
		_sharedNoticeView.backgroundColor = [UIColor blackColor];
		_sharedNoticeView.alpha = 0.f;
		_sharedNoticeView.textColor = [UIColor whiteColor];
		_sharedNoticeView.numberOfLines = 0;
		_sharedNoticeView.textAlignment = NSTextAlignmentCenter;
		_sharedNoticeView.layer.masksToBounds = YES;
		_sharedNoticeView.layer.cornerRadius = WCornerRadius;
	});
	return _sharedNoticeView;
}

- (void)setText:(NSString *)text{
	[super setText:text];
	//	[_sharedAlertView sizeToFit];
	UIFont *tfont = self.font;
	// 获取当前文本的属性
	NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont, NSFontAttributeName, nil];
	//ios7方法，获取文本需要的size，限制宽度
	CGSize actualsize =[text boundingRectWithSize:CGSizeMake(WScreenWidth - 64, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
	
	// 更新 UILabel 的 bounds
	self.bounds = CGRectMake(0 , 0, actualsize.width + 32, MAX(40, actualsize.height + 16));
}

- (void)showNoticeViewWithString:(NSString *)notice{
	if (self.superview) {
		[self removeTimer];
	}
	_sharedNoticeView.timer = [NSTimer scheduledTimerWithTimeInterval:WAlertViewShowTime target:[WNoticeView class] selector:@selector(hideNoticeView) userInfo:nil repeats:NO];
	self.text = notice;
	[WAppDelegate.window addSubview:self];
	[UIView animateWithDuration:WAnimationTime * 2 animations:^{
		self.alpha = 0.8f;
	}];
}

+ (void)showNoticeViewWithString:(NSString *)notice{
	[[self sharedNoticeView] showNoticeViewWithString:notice];
}

- (void)removeTimer{
	if ([self.timer isValid]) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

+ (void)hideNoticeView{
	[[self sharedNoticeView] hideNoticeView];
}

- (void)hideNoticeView{
	if (!self.superview) {
		return;
	}
	[UIView animateWithDuration:WAnimationTime * 2 animations:^{
		self.alpha = 0.0f;
	} completion:^(BOOL finished) {
		if (finished) {
			[self removeTimer];
			[self removeFromSuperview];
		}
	}];
}

@end
