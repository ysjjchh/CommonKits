//
//  UIView+MainThread.m
//  FddOrder
//
//  Created by ysjjchh on 16/5/25.
//  Copyright © 2016年 fangdd. All rights reserved.
//

#import "UIView+MainThread.h"
#import <objc/runtime.h>

@implementation UIView (MainThread)

- (void)swizzled_setNeedsLayout {
    
    if (![NSThread isMainThread]) {
        NSLog(@"setNeedsLayout not in main thread!!!!!!!!  %@", self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swizzled_setNeedsLayout];
        });
    } else {
        [self swizzled_setNeedsLayout];
    }
}

- (void)swizzled_setNeedsDisplay {
    if (![NSThread isMainThread]) {
        NSLog(@"setNeedsDisplay not in main thread!!!!!!!!  %@", self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swizzled_setNeedsDisplay];
        });
    } else {
        [self swizzled_setNeedsDisplay];
    }
}

- (void)swizzled_setNeedsDisplayInRect:(CGRect)rect {

    if (![NSThread isMainThread]) {
        NSLog(@"setNeedsDisplayInRect not in main thread!!!!!!!!  %@", self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swizzled_setNeedsDisplayInRect:rect];
        });
    } else {
        [self swizzled_setNeedsDisplayInRect:rect];
    }
}

+ (void)hookMainThread
{

    Method original, swizzle;
    
    original = class_getInstanceMethod(self, @selector(setNeedsLayout));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_setNeedsLayout));
    method_exchangeImplementations(original, swizzle);
    
    original = class_getInstanceMethod(self, @selector(setNeedsDisplay));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_setNeedsDisplay));
    method_exchangeImplementations(original, swizzle);
    
    original = class_getInstanceMethod(self, @selector(setNeedsDisplayInRect:));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_setNeedsDisplayInRect:));
    method_exchangeImplementations(original, swizzle);
}

@end
