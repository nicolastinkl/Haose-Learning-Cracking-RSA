#line 1 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/Hookhaosexians/Hookhaosexians/Hookhaosexians.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>

#import <AdSupport/ASIdentifierManager.h>
#import <dlfcn.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#import <mach-o/arch.h>
#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

#include <substrate.h>

#include <stdio.h>
#include <dlfcn.h>

#include <pthread.h>
#include <stdio.h>


#import "RNSScreen.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class RCTScrollView; @class AppDelegate; @class RCTCustomScrollView; @class ClassName; @class NSData; @class RNServiceConnect; @class RNSScreen; 
static id (*_logos_meta_orig$_ungrouped$ClassName$sharedInstance)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static id _logos_meta_method$_ungrouped$ClassName$sharedInstance(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$)(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$ClassName$messageWithReturnAndNoArguments)(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL); static id _logos_method$_ungrouped$ClassName$messageWithReturnAndNoArguments(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static void _logos_method$_ungrouped$RNSScreen$setMyTimer$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, NSTimer *); static NSTimer * _logos_method$_ungrouped$RNSScreen$myTimer(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$RNSScreen$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$_ungrouped$RNSScreen$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, bool); static UIImage * _logos_method$_ungrouped$RNSScreen$imageWithColor$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$_ungrouped$RNSScreen$testTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$_ungrouped$RNSScreen$startTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$_ungrouped$RNSScreen$checkTopViewController(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$RNSScreen$endTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static RCTScrollView* (*_logos_orig$_ungrouped$RCTScrollView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT RCTScrollView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static RCTScrollView* _logos_method$_ungrouped$RCTScrollView$initWithFrame$(_LOGOS_SELF_TYPE_INIT RCTScrollView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$)(_LOGOS_SELF_TYPE_NORMAL RCTScrollView* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$(_LOGOS_SELF_TYPE_NORMAL RCTScrollView* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_orig$_ungrouped$RCTCustomScrollView$handleCustomPan$)(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, void *); static void _logos_method$_ungrouped$RCTCustomScrollView$handleCustomPan$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, void *); static void _logos_method$_ungrouped$RCTCustomScrollView$handleNotification$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, NSNotification *); static NSData * (*_logos_orig$_ungrouped$NSData$subdataWithRange$)(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSRange); static NSData * _logos_method$_ungrouped$NSData$subdataWithRange$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSRange); static NSString * _logos_method$_ungrouped$NSData$base64StringFromData$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSData *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$RNServiceConnect(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("RNServiceConnect"); } return _klass; }
#line 31 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/Hookhaosexians/Hookhaosexians/Hookhaosexians.xm"



static id _logos_meta_method$_ungrouped$ClassName$sharedInstance(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSLog(@"+[<ClassName: %p> sharedInstance]", self);

	return _logos_meta_orig$_ungrouped$ClassName$sharedInstance(self, _cmd);
}


static void _logos_method$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id originalArgument) {
	NSLog(@"-[<ClassName: %p> messageWithNoReturnAndOneArgument:%@]", self, originalArgument);

	_logos_orig$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$(self, _cmd, originalArgument);
	
	
}


static id _logos_method$_ungrouped$ClassName$messageWithReturnAndNoArguments(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSLog(@"-[<ClassName: %p> messageWithReturnAndNoArguments]", self);

	id originalReturnOfMessage = _logos_orig$_ungrouped$ClassName$messageWithReturnAndNoArguments(self, _cmd);
	
	

	return originalReturnOfMessage;
}






static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application, NSDictionary * launchOptions) {
    BOOL result = _logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, launchOptions);
   
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"    注入成功，请放心使用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];






    

   
    return result;
}






 


static void _logos_method$_ungrouped$RNSScreen$setMyTimer$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSTimer * timer) {
    objc_setAssociatedObject(self, @selector(myTimer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static NSTimer * _logos_method$_ungrouped$RNSScreen$myTimer(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return objc_getAssociatedObject(self, @selector(myTimer));
}

static void _logos_method$_ungrouped$RNSScreen$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg2) {
    _logos_orig$_ungrouped$RNSScreen$viewDidAppear$(self, _cmd, arg2);
    UIView * view = self.view;
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100, 60, 40);
    startButton.backgroundColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.7];
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:startButton];

    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60 + 20, 60, 40);
    endButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButton setTitle:@"结束" forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(endTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButton];
    
    
    
    
    UIButton *endButtonTest = [UIButton buttonWithType:UIButtonTypeCustom];
    endButtonTest.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60*2 + 20, 60, 40);
    endButtonTest.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButtonTest setTitle:@"测试请求" forState:UIControlStateNormal];
    [endButtonTest addTarget:self action:@selector(testTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButtonTest];
    
    
    
    UIColor *highlightedColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    [startButton setBackgroundImage:[self imageWithColor:highlightedColor] forState:UIControlStateHighlighted];

    [endButton setBackgroundImage:[self imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    
}


static UIImage * _logos_method$_ungrouped$RNSScreen$imageWithColor$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


static void _logos_method$_ungrouped$RNSScreen$testTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    
    
    
    RNServiceConnect * rnConnect = [[_logos_static_class_lookup$RNServiceConnect() alloc] init];
    [rnConnect rnSendGetRequest:@{@"p":@"/app/video/clarity",@"s":@"vdbase"} authorization:@"1QoA7juDjTHsaK49f5RHYuvshxVv5VskGmlYIc9RsLX3ythXM9MN2Gev147tBLiNg3pKWJ3J7lTS1CZoEdn8-4A1i-uxTQKc6sbUnOCo4p2VLV6_MiHzc8BouPiA7w5H" data:@"{\"userid\":\"4yb81d\",\"res_key\":\"xsej4xjm2ur\"}" resolve:^(id result) {
        
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        
    }];
    
    
    

}


static void _logos_method$_ungrouped$RNSScreen$startTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    [sender setTitle:@"运行中" forState:UIControlStateNormal];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkTopViewController) userInfo:nil repeats:YES];

      

    
    
}


static void _logos_method$_ungrouped$RNSScreen$checkTopViewController(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
    NSLog(@"timer event  ... ");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotificationName_ScrollToEnd" object:nil];

   
   
}


static void _logos_method$_ungrouped$RNSScreen$endTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    
    



















    if(self.myTimer){
        
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
    
    
}







static RCTScrollView* _logos_method$_ungrouped$RCTScrollView$initWithFrame$(_LOGOS_SELF_TYPE_INIT RCTScrollView* __unused self, SEL __unused _cmd, CGRect arg2) _LOGOS_RETURN_RETAINED {

    NSLog(@"-[<RCTScrollView: %p> initWithFrame:{{%g, %g}, {%g, %g}}]", self, arg2.origin.x, arg2.origin.y, arg2.size.width, arg2.size.height);
    return _logos_orig$_ungrouped$RCTScrollView$initWithFrame$(self, _cmd, arg2);
}


static void _logos_method$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$(_LOGOS_SELF_TYPE_NORMAL RCTScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg2) {
    NSLog(@"-[<RCTScrollView: %p> setShowsHorizontalScrollIndicator:%d]", self, arg2);
     _logos_orig$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$(self, _cmd, arg2);
}










static void _logos_method$_ungrouped$RCTCustomScrollView$handleCustomPan$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void * arg2) {
    _logos_orig$_ungrouped$RCTCustomScrollView$handleCustomPan$(self, _cmd, arg2);
    NSLog(@"-[<RCTCustomScrollView: %p> handleCustomPan:%p]", self, arg2);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.frame.size.width > 100){
         
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
           name:@"MyNotificationName_ScrollToEnd" object:nil];
    }
    
}



static void _logos_method$_ungrouped$RCTCustomScrollView$handleNotification$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification * notification) {
    
    NSLog(@"handleNotification  scroll to bottom");

   
    
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height+100);
    [self setContentOffset:bottomOffset animated:YES];


}







static NSData * _logos_method$_ungrouped$NSData$subdataWithRange$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSRange range) {
    
    NSRange modifiedRange = NSMakeRange(range.location, range.length);
    NSLog(@"subdataWithRange %lu  %lu",range.location,range.length);
    
    
    
    NSData *originalData = _logos_orig$_ungrouped$NSData$subdataWithRange$(self, _cmd, modifiedRange);
   
    NSLog(@"Self: %@", [self performSelector:@selector(base64StringFromData:) withObject:self]);
    NSLog(@"originalData: %@", [self performSelector:@selector(base64StringFromData:) withObject:originalData]);
    return originalData;
}





static NSString * _logos_method$_ungrouped$NSData$base64StringFromData$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData * data) {
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        
        
        static char encodingTable[100] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";



        
        
        static NSUInteger paddingTable[] = {0,2,1};
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = dataLength / 3;
        if( (encodedBlocks + 1) >= (NSUIntegerMax / 4) ) return nil; 

        
        NSUInteger padding = paddingTable[dataLength % 3];

        
        if( padding > 0 ) encodedBlocks++;

        
        NSUInteger encodedLength = encodedBlocks * 4;

        
        void *ptr = malloc(encodedLength);

        encodingBytes = (unsigned char *)ptr;

        
        if( encodingBytes != NULL ) {
            
            NSUInteger rawBytesToProcess = dataLength;
            
            NSUInteger rawBaseIndex = 0;
            
            NSUInteger encodingBaseIndex = 0;
            
            unsigned char *rawBytes = (unsigned char *)[data bytes];

            
            unsigned char rawByte1, rawByte2, rawByte3;
            
            while( rawBytesToProcess >= 3 ) {
                
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];

                
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];

                
                rawBaseIndex += 3;
                
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    
                    break;
            }
            
            
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$ClassName = objc_getClass("ClassName"); Class _logos_metaclass$_ungrouped$ClassName = object_getClass(_logos_class$_ungrouped$ClassName); { MSHookMessageEx(_logos_metaclass$_ungrouped$ClassName, @selector(sharedInstance), (IMP)&_logos_meta_method$_ungrouped$ClassName$sharedInstance, (IMP*)&_logos_meta_orig$_ungrouped$ClassName$sharedInstance);}{ MSHookMessageEx(_logos_class$_ungrouped$ClassName, @selector(messageWithNoReturnAndOneArgument:), (IMP)&_logos_method$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$, (IMP*)&_logos_orig$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$);}{ MSHookMessageEx(_logos_class$_ungrouped$ClassName, @selector(messageWithReturnAndNoArguments), (IMP)&_logos_method$_ungrouped$ClassName$messageWithReturnAndNoArguments, (IMP*)&_logos_orig$_ungrouped$ClassName$messageWithReturnAndNoArguments);}Class _logos_class$_ungrouped$AppDelegate = objc_getClass("AppDelegate"); { MSHookMessageEx(_logos_class$_ungrouped$AppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$);}Class _logos_class$_ungrouped$RNSScreen = objc_getClass("RNSScreen"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(setMyTimer:), (IMP)&_logos_method$_ungrouped$RNSScreen$setMyTimer$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(myTimer), (IMP)&_logos_method$_ungrouped$RNSScreen$myTimer, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$RNSScreen, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$RNSScreen$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$RNSScreen$viewDidAppear$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIColor *), strlen(@encode(UIColor *))); i += strlen(@encode(UIColor *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(imageWithColor:), (IMP)&_logos_method$_ungrouped$RNSScreen$imageWithColor$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(testTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$testTask$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(startTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$startTask$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(checkTopViewController), (IMP)&_logos_method$_ungrouped$RNSScreen$checkTopViewController, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(endTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$endTask$, _typeEncoding); }Class _logos_class$_ungrouped$RCTScrollView = objc_getClass("RCTScrollView"); { MSHookMessageEx(_logos_class$_ungrouped$RCTScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$RCTScrollView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$RCTScrollView$initWithFrame$);}{ MSHookMessageEx(_logos_class$_ungrouped$RCTScrollView, @selector(setShowsHorizontalScrollIndicator:), (IMP)&_logos_method$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$, (IMP*)&_logos_orig$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$);}Class _logos_class$_ungrouped$RCTCustomScrollView = objc_getClass("RCTCustomScrollView"); { MSHookMessageEx(_logos_class$_ungrouped$RCTCustomScrollView, @selector(handleCustomPan:), (IMP)&_logos_method$_ungrouped$RCTCustomScrollView$handleCustomPan$, (IMP*)&_logos_orig$_ungrouped$RCTCustomScrollView$handleCustomPan$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RCTCustomScrollView, @selector(handleNotification:), (IMP)&_logos_method$_ungrouped$RCTCustomScrollView$handleNotification$, _typeEncoding); }Class _logos_class$_ungrouped$NSData = objc_getClass("NSData"); { MSHookMessageEx(_logos_class$_ungrouped$NSData, @selector(subdataWithRange:), (IMP)&_logos_method$_ungrouped$NSData$subdataWithRange$, (IMP*)&_logos_orig$_ungrouped$NSData$subdataWithRange$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSData *), strlen(@encode(NSData *))); i += strlen(@encode(NSData *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NSData, @selector(base64StringFromData:), (IMP)&_logos_method$_ungrouped$NSData$base64StringFromData$, _typeEncoding); }} }
#line 421 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/Hookhaosexians/Hookhaosexians/Hookhaosexians.xm"
