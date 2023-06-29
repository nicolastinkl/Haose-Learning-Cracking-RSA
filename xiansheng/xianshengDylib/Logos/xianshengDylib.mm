#line 1 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/all_haosexiansheng/xiansheng/xianshengDylib/Logos/xianshengDylib.xm"


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
#import "TNetwork.h"
#import "HDWindowLogger.h"



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

@class RNSScreen; @class AESUtils; @class RCTCustomScrollView; @class AppDelegate; @class RNServiceConnect; @class RCTScrollView; @class ClassName; 
static id (*_logos_meta_orig$_ungrouped$ClassName$sharedInstance)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static id _logos_meta_method$_ungrouped$ClassName$sharedInstance(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$)(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL, id); static id (*_logos_orig$_ungrouped$ClassName$messageWithReturnAndNoArguments)(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL); static id _logos_method$_ungrouped$ClassName$messageWithReturnAndNoArguments(_LOGOS_SELF_TYPE_NORMAL ClassName* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, NSDictionary *); static void (*_logos_orig$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$)(_LOGOS_SELF_TYPE_NORMAL RNServiceConnect* _LOGOS_SELF_CONST, SEL, NSDictionary *, NSString *, NSString*, id, id); static void _logos_method$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$(_LOGOS_SELF_TYPE_NORMAL RNServiceConnect* _LOGOS_SELF_CONST, SEL, NSDictionary *, NSString *, NSString*, id, id); static void _logos_method$_ungrouped$RNSScreen$setMyTimer$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, NSTimer *); static NSTimer * _logos_method$_ungrouped$RNSScreen$myTimer(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$RNSScreen$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$_ungrouped$RNSScreen$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, bool); static UIImage * _logos_method$_ungrouped$RNSScreen$imageWithColor$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$_ungrouped$RNSScreen$testTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$_ungrouped$RNSScreen$startTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$_ungrouped$RNSScreen$checkTopViewController(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$RNSScreen$endTask$(_LOGOS_SELF_TYPE_NORMAL RNSScreen* _LOGOS_SELF_CONST, SEL, UIButton *); static RCTScrollView* (*_logos_orig$_ungrouped$RCTScrollView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT RCTScrollView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static RCTScrollView* _logos_method$_ungrouped$RCTScrollView$initWithFrame$(_LOGOS_SELF_TYPE_INIT RCTScrollView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$)(_LOGOS_SELF_TYPE_NORMAL RCTScrollView* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$(_LOGOS_SELF_TYPE_NORMAL RCTScrollView* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_orig$_ungrouped$RCTCustomScrollView$handleCustomPan$)(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, void *); static void _logos_method$_ungrouped$RCTCustomScrollView$handleCustomPan$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, void *); static void _logos_method$_ungrouped$RCTCustomScrollView$handleNotification$(_LOGOS_SELF_TYPE_NORMAL RCTCustomScrollView* _LOGOS_SELF_CONST, SEL, NSNotification *); static NSData * (*_logos_meta_orig$_ungrouped$AESUtils$decryptWithCBC$key$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSString *); static NSData * _logos_meta_method$_ungrouped$AESUtils$decryptWithCBC$key$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSString *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$RNServiceConnect(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("RNServiceConnect"); } return _klass; }
#line 34 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/all_haosexiansheng/xiansheng/xianshengDylib/Logos/xianshengDylib.xm"



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




__attribute__ ((constructor))
static void init_hooking(void) {
}




static BOOL _logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL AppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application, NSDictionary * launchOptions) {
    BOOL result = _logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, application, launchOptions);
   
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"    注入成功，请放心使用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    
    [HDWindowLogger defaultWindowLogger].mCompleteLogOut = false;
    [HDWindowLogger show];
    [HDWindowLogger defaultWindowLogger].mPrivacyPassword = @"12345678901234561234567890123456";
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"udpatetext" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSString * text =  [note.userInfo valueForKey:@"text"];
        HDNormalLog(text);
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"execnotify" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        
        __block NSString * authorization = [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization"];

        
        NSTimer * timer2 = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            

          
            
            NSArray *taskList = [[NSUserDefaults standardUserDefaults] objectForKey:@"TaskList"];
            if(taskList.count > 0){
                
                NSMutableArray *mutableTaskList = [taskList mutableCopy];
                NSDictionary *task =  mutableTaskList.firstObject;
                [mutableTaskList removeObjectAtIndex:0];
                
                
                
                NSString * res_key = [task valueForKey:@"res_key"];
                HDDebugLog(@"Task正在执行任务res_key:  : %@",res_key);
                
                
                RNServiceConnect * rnConnect = [[_logos_static_class_lookup$RNServiceConnect() alloc] init];
                [[NSUserDefaults standardUserDefaults] setObject:res_key forKey:@"current_res_key"];
                [rnConnect rnSendGetRequest:@{@"p":@"/app/video/clarity",@"s":@"vdbase"} authorization:authorization data:[NSString stringWithFormat:@"{\"userid\":\"4yb81d\",\"res_key\":\"%@\"}",res_key] resolve:^(id result) {
                    
                } rejecter:^(NSString *code, NSString *message, NSError *error) {
                    
                }];
                
                
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"udpatetext" object:nil userInfo:@{@"text":[NSString stringWithFormat:@"剩余任务：%lu res_key: %@",taskList.count,res_key]}];
                
                [[NSUserDefaults standardUserDefaults] setObject:mutableTaskList forKey:@"TaskList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                
                [timer invalidate];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频解析任务结束" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }];
        
        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
        
    }];
    
     
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"pushtoserverjsontext" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSString * jsontext =  [note.userInfo valueForKey:@"jsontext"];
        NSString * current_res_key= [[NSUserDefaults standardUserDefaults] objectForKey:@"current_res_key"];
        
        [TNetwork POSTRequestJSON:[NSString stringWithFormat:@"https://api.dcgvc.com/flutter/api/pushvideourl.php?current_res_key=%@",current_res_key] RequestParamsString:jsontext FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSString * resonsessstr = [[NSString alloc] initWithData:data encoding:4];
            if(resonsessstr ){
                NSLog(@"response : %@",resonsessstr);
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"udpatetext" object:nil userInfo:@{@"text":[NSString stringWithFormat:@"提交Video信息服务器返回： %@",resonsessstr]}];

                
            }else{
                
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"udpatetext" object:nil userInfo:@{@"text":@"提交失败，请检查服务器"}];
            }
        }];
    }];
    
    
    
    
    NSTimer * timer2 = [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [HDWindowLogger cleanLog];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
    






    

   
    return result;
}























static void _logos_method$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$(_LOGOS_SELF_TYPE_NORMAL RNServiceConnect* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * arg2, NSString * arg3, NSString* arg4, id arg5, id arg6) {
    NSLog(@"-[<RNServiceConnect: %p> rnSendGetRequest:%@ authorization:%@ data:%@ resolve:%@ rejecter:%@]", self, arg2, arg3, arg4, arg5, arg6);
    if(arg2){
        NSString * clarity = [arg2 valueForKey:@"p"];
        if([clarity isEqualToString:@"/app/video/clarity"]){
            
            [[NSUserDefaults standardUserDefaults] setObject:arg3 forKey:@"authorization"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    _logos_orig$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$(self, _cmd, arg2,arg3,arg4,arg5,arg6);
    
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
    startButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60 + 20, 60, 40);
    endButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButton setTitle:@"结束" forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(endTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButton];
    
    endButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    
    
    
    UIButton *endButtonTest = [UIButton buttonWithType:UIButtonTypeCustom];
    endButtonTest.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60*2 + 20, 60, 40);
    endButtonTest.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButtonTest setTitle:@"视频解密" forState:UIControlStateNormal];
    [endButtonTest addTarget:self action:@selector(testTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButtonTest];
    
    endButtonTest.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    
    
    
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
    
    
    

    
    
      
      NSArray *taskList = [[NSUserDefaults standardUserDefaults] objectForKey:@"TaskList"];
    if(taskList.count > 0){
        
        HDDebugLog(@"开始任务...");
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"execnotify" object:nil userInfo:@{}];
         
        
    }else{
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString * deviceName = idfv;
        NSString * ad= [NSString stringWithFormat:@"https://api.dcgvc.com/flutter/api/gettasklist.php?devicesid=%@",deviceName];
        
        [TNetwork GETRequest:ad   FinishBlock:^(NSURLResponse *response, NSData *resposneData, NSError *connectionError) {
            if (resposneData) {
                NSString * resonsessstr = [[NSString alloc] initWithData:resposneData encoding:4];
                if(resonsessstr ){
                    
                    [[NSNotificationCenter defaultCenter]  postNotificationName:@"udpatetext" object:nil userInfo:@{@"text":[NSString stringWithFormat:@"resonsessstrx 配置信息   >>>>>>>>>>"]}];
                    
                    
                    id json = [NSJSONSerialization JSONObjectWithData:resposneData options:(NSJSONReadingMutableContainers) error:nil];
                    HDDebugLog(@"resonsessstrx 配置信息   >>>>>>>>>> ");
                    if (json && [json valueForKey:@"data"]) {
                        NSArray * data = [json valueForKey:@"data"];
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"TaskList"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        if(data == nil){
                            return;
                        }
                        HDDebugLog(@"开始任务...");
                        [[NSNotificationCenter defaultCenter]  postNotificationName:@"execnotify" object:nil userInfo:@{}];

                    }
                }
            }
        }];
    }
    
   
    
  
    
    
    

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







static NSData * _logos_meta_method$_ungrouped$AESUtils$decryptWithCBC$key$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData * arg2, NSString * arg3){
    NSData * resultdata = _logos_meta_orig$_ungrouped$AESUtils$decryptWithCBC$key$(self, _cmd, arg2,arg3);
    NSString *string = [[NSString alloc] initWithData:resultdata encoding:NSUTF8StringEncoding];

    if(string!=nil && string.length>100){
        
        if([string containsString:@"clarity_id"] && [string containsString:@"video_uri"]){
            
            
            
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"pushtoserverjsontext" object:nil userInfo:@{@"jsontext":string}];
            string = [string substringToIndex:98];
            HDNormalLog(string);
        }
        
        if([string containsString:@"clarity_id"] && [string containsString:@"video_uri"]){
            
            
            
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"pushtoserverjsontext" object:nil userInfo:@{@"jsontext":string}];
            string = [string substringToIndex:98];
            HDNormalLog(string);
        }
        
        
    }
   
    
    
    return resultdata;
}


















































































































































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$ClassName = objc_getClass("ClassName"); Class _logos_metaclass$_ungrouped$ClassName = object_getClass(_logos_class$_ungrouped$ClassName); { MSHookMessageEx(_logos_metaclass$_ungrouped$ClassName, @selector(sharedInstance), (IMP)&_logos_meta_method$_ungrouped$ClassName$sharedInstance, (IMP*)&_logos_meta_orig$_ungrouped$ClassName$sharedInstance);}{ MSHookMessageEx(_logos_class$_ungrouped$ClassName, @selector(messageWithNoReturnAndOneArgument:), (IMP)&_logos_method$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$, (IMP*)&_logos_orig$_ungrouped$ClassName$messageWithNoReturnAndOneArgument$);}{ MSHookMessageEx(_logos_class$_ungrouped$ClassName, @selector(messageWithReturnAndNoArguments), (IMP)&_logos_method$_ungrouped$ClassName$messageWithReturnAndNoArguments, (IMP*)&_logos_orig$_ungrouped$ClassName$messageWithReturnAndNoArguments);}Class _logos_class$_ungrouped$AppDelegate = objc_getClass("AppDelegate"); { MSHookMessageEx(_logos_class$_ungrouped$AppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$AppDelegate$application$didFinishLaunchingWithOptions$);}Class _logos_class$_ungrouped$RNServiceConnect = objc_getClass("RNServiceConnect"); { MSHookMessageEx(_logos_class$_ungrouped$RNServiceConnect, @selector(rnSendGetRequest:authorization:data:resolve:rejecter:), (IMP)&_logos_method$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$, (IMP*)&_logos_orig$_ungrouped$RNServiceConnect$rnSendGetRequest$authorization$data$resolve$rejecter$);}Class _logos_class$_ungrouped$RNSScreen = objc_getClass("RNSScreen"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(setMyTimer:), (IMP)&_logos_method$_ungrouped$RNSScreen$setMyTimer$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(myTimer), (IMP)&_logos_method$_ungrouped$RNSScreen$myTimer, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$RNSScreen, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$RNSScreen$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$RNSScreen$viewDidAppear$);}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIColor *), strlen(@encode(UIColor *))); i += strlen(@encode(UIColor *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(imageWithColor:), (IMP)&_logos_method$_ungrouped$RNSScreen$imageWithColor$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(testTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$testTask$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(startTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$startTask$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(checkTopViewController), (IMP)&_logos_method$_ungrouped$RNSScreen$checkTopViewController, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RNSScreen, @selector(endTask:), (IMP)&_logos_method$_ungrouped$RNSScreen$endTask$, _typeEncoding); }Class _logos_class$_ungrouped$RCTScrollView = objc_getClass("RCTScrollView"); { MSHookMessageEx(_logos_class$_ungrouped$RCTScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$RCTScrollView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$RCTScrollView$initWithFrame$);}{ MSHookMessageEx(_logos_class$_ungrouped$RCTScrollView, @selector(setShowsHorizontalScrollIndicator:), (IMP)&_logos_method$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$, (IMP*)&_logos_orig$_ungrouped$RCTScrollView$setShowsHorizontalScrollIndicator$);}Class _logos_class$_ungrouped$RCTCustomScrollView = objc_getClass("RCTCustomScrollView"); { MSHookMessageEx(_logos_class$_ungrouped$RCTCustomScrollView, @selector(handleCustomPan:), (IMP)&_logos_method$_ungrouped$RCTCustomScrollView$handleCustomPan$, (IMP*)&_logos_orig$_ungrouped$RCTCustomScrollView$handleCustomPan$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$RCTCustomScrollView, @selector(handleNotification:), (IMP)&_logos_method$_ungrouped$RCTCustomScrollView$handleNotification$, _typeEncoding); }Class _logos_class$_ungrouped$AESUtils = objc_getClass("AESUtils"); Class _logos_metaclass$_ungrouped$AESUtils = object_getClass(_logos_class$_ungrouped$AESUtils); { MSHookMessageEx(_logos_metaclass$_ungrouped$AESUtils, @selector(decryptWithCBC:key:), (IMP)&_logos_meta_method$_ungrouped$AESUtils$decryptWithCBC$key$, (IMP*)&_logos_meta_orig$_ungrouped$AESUtils$decryptWithCBC$key$);}} }
#line 645 "/Users/nantian/Documents/yueyu/ios/frida_ios_android_script/frida-script-ios/all_haosexiansheng/xiansheng/xianshengDylib/Logos/xianshengDylib.xm"
