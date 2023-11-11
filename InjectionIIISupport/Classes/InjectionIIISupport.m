//
//  InjectionIIISupport.h
//  InjectionIIISupport
//
//  Created by zengjing on 11/11/2023.
//  Copyright (c) 2023 zengjing. All rights reserved.
//

#import "InjectionIIISupport.h"
#import <objc/runtime.h>

@interface UIView (InjectionIIISupport)

@end

@interface UIViewController (InjectionIIISupport)

- (void)dz_hotReload;

@end

@implementation UIView (InjectionIIISupport)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(self, @selector(init));
        Method method2 = class_getInstanceMethod(self, @selector(dz_init));
        method_exchangeImplementations(method1, method2);
    });
}

- (instancetype)dz_init {
    id self1 = [self dz_init];
    if (self1) {
        [[NSNotificationCenter defaultCenter] addObserver:self1 selector:@selector(dz_injected:) name:@"INJECTION_BUNDLE_NOTIFICATION" object:nil];
    }
    return self1;
}

- (void)dz_injected:(NSNotification *)notification {
    NSArray *array = notification.object;
    for (id obj in array) {
        if ([self isKindOfClass:[obj class]]) {
            UIViewController *controller = [self dz_parentViewController];
            if (controller) {
                [controller dz_hotReload];
            }
        }
    }
}

- (UIViewController *)dz_parentViewController {
    UIView *view = self;
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            [(UITableView *)nextResponder reloadData];
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

@implementation UIViewController (InjectionIIISupport)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(self, @selector(init));
        Method method2 = class_getInstanceMethod(self, @selector(dz_init));
        method_exchangeImplementations(method1, method2);
    });
}

- (instancetype)dz_init {
    id self1 = [self dz_init];
    if (self1) {
        [[NSNotificationCenter defaultCenter] addObserver:self1 selector:@selector(dz_injected:) name:@"INJECTION_BUNDLE_NOTIFICATION" object:nil];
    }
    return self1;
}

- (void)dz_injected:(NSNotification *)notification {
    NSArray *array = notification.object;
    for (id obj in array) {
        if ([self isKindOfClass:[obj class]]) {
            [self dz_hotReload];
        }
    }
}

- (void)dz_hotReload {
    UIViewController *vc = (UIViewController *)self;
    [vc.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self dz_resetLazyProperties];

    [self viewDidLoad];
    [self viewWillAppear:NO];
    [self viewWillLayoutSubviews];
    [self viewDidLayoutSubviews];
    [self viewDidAppear:NO];
}

- (void)dz_resetLazyProperties {
    UIViewController *vc = self;
    unsigned int propertyCount;
    objc_property_t *propertys = class_copyPropertyList(vc.class, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertys[i];
        const char *cPropertyName = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
        id propertyValue = [vc valueForKey:propertyName];
        if ([propertyValue isKindOfClass:UIView.class]) {
            @try {
                [vc setValue:nil forKey:propertyName];
            } @catch (NSException *exception) {
                // NSLog(@"exception = %@", exception);
            } @finally {
            }
        }
    }
    free(propertys);
}

@end

@implementation InjectionIIISupport

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                                            object:nil
                                                                             queue:nil
                                                                        usingBlock:^(NSNotification *_Nonnull note) {
                                                                            NSLog(@"[InjectionIII] 装载 iOSInjection.bundle");
                                                                            [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
                                                                            [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                            observer = nil;
                                                                        }];
}

@end
