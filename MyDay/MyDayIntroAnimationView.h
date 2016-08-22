//
// MyDayIntroAnimationView.h
// Generated by Core Animator version 1.3 on 8/22/16.
//
// DO NOT MODIFY THIS FILE. IT IS AUTO-GENERATED AND WILL BE OVERWRITTEN
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MyDayIntroAnimationView : UIView

@property (strong, nonatomic) NSDictionary *viewsByName;

// my day intro
- (void)addMyDayIntroAnimation;
- (void)addMyDayIntroAnimationWithCompletion:(void (^)(BOOL finished))completionBlock;
- (void)addMyDayIntroAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion;
- (void)addMyDayIntroAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock;
- (void)addMyDayIntroAnimationWithBeginTime:(CFTimeInterval)beginTime andFillMode:(NSString *)fillMode andRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock;
- (void)removeMyDayIntroAnimation;

- (void)removeAllAnimations;

@end