// See http://iphonedevwiki.net/index.php/Logos

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

%hook ClassName

+ (id)sharedInstance
{
	%log;

	return %orig;
}

- (void)messageWithNoReturnAndOneArgument:(id)originalArgument
{
	%log;

	%orig(originalArgument);
	
	// or, for exmaple, you could use a custom value instead of the original argument: %orig(customValue);
}

- (id)messageWithReturnAndNoArguments
{
	%log;

	id originalReturnOfMessage = %orig;
	
	// for example, you could modify the original return value before returning it: [SomeOtherClass doSomethingToThisObject:originalReturnOfMessage];

	return originalReturnOfMessage;
}

%end


%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig(application, launchOptions);
   
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"    注入成功，请放心使用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"    注入成功，请放心使用" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:okAction];
//    [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];

    // 在这里添加你要执行的代码
//    NSLog(@"%@",@"注入=====================OK");
   
    return result;
}


%end


%hook RNSScreen
 

%new
- (void)setMyTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, @selector(myTimer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (NSTimer *)myTimer {
    return objc_getAssociatedObject(self, @selector(myTimer));
}

-(void)viewDidAppear:(bool)arg2 {
    %orig(arg2);
    UIView * view = self.view;
    // 创建开始任务按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100, 60, 40);
    startButton.backgroundColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.7];
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:startButton];

    // 创建结束任务按钮
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60 + 20, 60, 40);
    endButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButton setTitle:@"结束" forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(endTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButton];
    
    
    
    // 创建测试案例
    UIButton *endButtonTest = [UIButton buttonWithType:UIButtonTypeCustom];
    endButtonTest.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100 + 60*2 + 20, 60, 40);
    endButtonTest.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.8];
    [endButtonTest setTitle:@"测试请求" forState:UIControlStateNormal];
    [endButtonTest addTarget:self action:@selector(testTask:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:endButtonTest];
    
    
    // 设置按钮的高亮时背景颜色
    UIColor *highlightedColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    [startButton setBackgroundImage:[self imageWithColor:highlightedColor] forState:UIControlStateHighlighted];

    [endButton setBackgroundImage:[self imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    
}

%new
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

%new
- (void)testTask:(UIButton *)sender {
    
    
    
    
    RNServiceConnect * rnConnect = [[%c(RNServiceConnect) alloc] init];
    [rnConnect rnSendGetRequest:@{@"p":@"/app/video/clarity",@"s":@"vdbase"} authorization:@"1QoA7juDjTHsaK49f5RHYuvshxVv5VskGmlYIc9RsLX3ythXM9MN2Gev147tBLiNg3pKWJ3J7lTS1CZoEdn8-4A1i-uxTQKc6sbUnOCo4p2VLV6_MiHzc8BouPiA7w5H" data:@"{\"userid\":\"4yb81d\",\"res_key\":\"xsej4xjm2ur\"}" resolve:^(id result) {
        
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        
    }];
    
    // {"code":0,"data":[{"clarity_id":"3","clarity_id_text":"高清","video_uri":"https://git.qiyezhushou.com.cn/cos/txvideo-new/scraper/bbb/mp4-720p/ts/82844b4c050977d7b7630f07fb61da07.m3u8","filesize":226455588}],"msg":"success"}
    
//    {"code":0,"data":[{"clarity_id":"3","clarity_id_text":"高清","video_uri":"https://git.qiyezhushou.com.cn/cos/txvideo/xsej4xjm2ur/ts/95bd890a736f410865c35dc9d3e92456.m3u8","filesize":23512220}],"msg":"success"}
}

%new
- (void)startTask:(UIButton *)sender {
    // 获取当前视图控制器
    [sender setTitle:@"运行中" forState:UIControlStateNormal];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkTopViewController) userInfo:nil repeats:YES];

      //  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self //selector:@selector(checkTopViewController) userInfo:nil repeats:YES];

    //UIViewController *topVC = [self topViewController];
    //NSLog(@"当前顶部视图：%@", NSStringFromClass([topVC class]));
}

%new
- (void)checkTopViewController {
    // 获取当前视图控制器
    NSLog(@"timer event  ... ");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotificationName_ScrollToEnd" object:nil];

   // UIViewController *topVC = [self topViewController];
   // NSLog(@"当前顶部视图：%@", NSStringFromClass([topVC class]));
}

%new
- (void)endTask:(UIButton *)sender {
    // 获取当前视图控制器
    // 停止定时器
    /***
     
     Mar 30 19:05:44 iPhone xianshen(Hookhaosexians.dylib)[36510] <Notice>: otherapp\M-o\M-<\M^ZPgqb/Oa4n6JbRlYBUHL8rtAbm3D/dqym0qeXvS0jwD3PAGJ410Upqla5dKFoClVxyO9v3MT29qCZWQsrEyPs+FCkFUCIMKso9ytSqFreZyq1CpPa+8bts6QLRo91OMN6ID2UaSpl81vjkj6kLQ9OEnU3GDTPAC9/7RlbukSPdEblk7UDkUG251uNXs/InBv5Lrq9jILo8cj8gOqTn1DfYRKp0dLpojSOPwgBD2AjYEyXaUu25CcElyu6SO63fINVMqoA0uNMOhW/qXK3VJFjWtER7iID3NVwf3f9qION11H0Q6SeOJ53rYlLlAEAJPfADpYDG8Pz/3E1zjpKT+Z2Dr7uFvrA+6cgis1MHFAVZ7jI0gJGCowVFKXE7/v+uJ4wwReZ0D2J4m6tFhUOIlLMUQ6fnAK3xd4FoW6oFVmby6IKJq/W9vNMQrVqVv4p5qDB5lga46+LWG4ckuo3JdNJCQ==
     Mar 30 19:05:44 iPhone xianshen(Hookhaosexians.dylib)[36510] <Notice>: subdataWithRange 16  336
     Mar 30 19:05:44 iPhone xianshen(Hookhaosexians.dylib)[36510] <Notice>: Self: Pgqb/Oa4n6JbRlYBUHL8rtAbm3D/dqym0qeXvS0jwD3PAGJ410Upqla5dKFoClVxyO9v3MT29qCZWQsrEyPs+FCkFUCIMKso9ytSqFreZyq1CpPa+8bts6QLRo91OMN6ID2UaSpl81vjkj6kLQ9OEnU3GDTPAC9/7RlbukSPdEblk7UDkUG251uNXs/InBv5Lrq9jILo8cj8gOqTn1DfYRKp0dLpojSOPwgBD2AjYEyXaUu25CcElyu6SO63fINVMqoA0uNMOhW/qXK3VJFjWtER7iID3NVwf3f9qION11H0Q6SeOJ53rYlLlAEAJPfADpYDG8Pz/3E1zjpKT+Z2Dr7uFvrA+6cgis1MHFAVZ7jI0gJGCowVFKXE7/v+uJ4wwReZ0D2J4m6tFhUOIlLMUQ6fnAK3xd4FoW6oFVmby6IKJq/W9vNMQrVqVv4p5qDB5lga46+LWG4ckuo3JdNJCQ==
     Mar 30 19:05:44 iPhone xianshen(Hookhaosexians.dylib)[36510] <Notice>: originalData: 0BubcP92rKbSp5e9LSPAPc8AYnjXRSmqVrl0oWgKVXHI72/cxPb2oJlZCysTI+z4UKQVQIgwqyj3K1KoWt5nKrUKk9r7xu2zpAtGj3U4w3ogPZRpKmXzW+OSPqQtD04SdTcYNM8AL3/tGVu6RI90RuWTtQORQbbnW41ez8icG/kuur2MgujxyPyA6pOfUN9hEqnR0umiNI4/CAEPYCNgTJdpS7bkJwSXK7pI7rd8g1UyqgDS40w6Fb+pcrdUkWNa0RHuIgPc1XB/d/2og43XUfRDpJ44nnetiUuUAQAk98AOlgMbw/P/cTXOOkpP5nYOvu4W+sD7pyCKzUwcUBVnuMjSAkYKjBUUpcTv+/64njDBF5nQPYnibq0WFQ4iUsxRDp+cArfF3gWhbqgVWZvLogomr9b280xCtWpW/inmoMHmWBrjr4tYbhyS6jcl00kJ
     Mar 30 19:05:44 iPhone xianshen(Hookhaosexians.dylib)[36510] <Notice>: \M-h\M-'\M-#\M-e\M-/\M^F\M-e\M^P\M^N\M-o\M-<\M^Zgs":{"liveBackUpUrls":"https://gotest3.ae9413.com;https://go.ae9413.com","liveJavaBackUpUrls":"https://java.yvfwov.com;https://java.8q60pt.com;https://java.g6mdhm.com;https://java.66r69l.com","liveNNUrl":"https://gotest.ae9413.com","liveOnFlag":false,"liveProductId":"G2001","liveUrl":"https://java.7190bc.com"},"msg":"success"}
     
 
    AESUtils  *aes = [[%c(AESUtils) alloc] init];
     NSString *  key = @"KWxyWZjXSjScGfp9BCrmHQ==";
     NSString * otherapp = @"Pgqb/Oa4n6JbRlYBUHL8rtAbm3D/dqym0qeXvS0jwD3PAGJ410Upqla5dKFoClVxyO9v3MT29qCZWQsrEyPs+FCkFUCIMKso9ytSqFreZyq1CpPa+8bts6QLRo91OMN6ID2UaSpl81vjkj6kLQ9OEnU3GDTPAC9/7RlbukSPdEblk7UDkUG251uNXs/InBv5Lrq9jILo8cj8gOqTn1DfYRKp0dLpojSOPwgBD2AjYEyXaUu25CcElyu6SO63fINVMqoA0uNMOhW/qXK3VJFjWtER7iID3NVwf3f9qION11H0Q6SeOJ53rYlLlAEAJPfADpYDG8Pz/3E1zjpKT+Z2Dr7uFvrA+6cgis1MHFAVZ7jI0gJGCowVFKXE7/v+uJ4wwReZ0D2J4m6tFhUOIlLMUQ6fnAK3xd4FoW6oFVmby6IKJq/W9vNMQrVqVv4p5qDB5lga46+LWG4ckuo3JdNJCQ==";
     NSLog(@"otherapp：%@",otherapp);
     NSData * ssss = [[NSData alloc] initWithBase64EncodedString:otherapp options:0];
     
     NSData *jimiehou = [aes baseDecrypt:ssss key:key cbcFlag:YES pos:16];
     NSString *str2 = [[NSString alloc] initWithData:jimiehou encoding:NSUTF8StringEncoding];
      
     NSLog(@"解密后：%@",str2);
     */
    if(self.myTimer){
        
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
    //UIViewController *topVC = [self topViewController];
    //NSLog(@"当前顶部视图：%@", NSStringFromClass([topVC class]));
}

%end



%hook RCTScrollView

-(id)initWithFrame:(CGRect)arg2 {

    %log;
    return %orig(arg2);
}


-(void)setShowsHorizontalScrollIndicator:(bool)arg2 {
    %log;
     %orig(arg2);
}

%end



//0x1e2b6e760 UIKitCore!-[UIView(Internal) _didMoveFromWindow:toWindow:]
//[+] 类 args[0]: <RCTCustomScrollView: 0x103549c00; baseClass = UIScrollView; frame = (0 0; 375 523);

%hook RCTCustomScrollView

-(void)handleCustomPan:(void *)arg2 {
    %orig(arg2);
    %log;
    // 判断这个Scrollview是否为正常大小
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.frame.size.width > 100){
         
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
           name:@"MyNotificationName_ScrollToEnd" object:nil];
    }
    
}


%new
- (void)handleNotification:(NSNotification *)notification {
    // 处理接收到的通知
    NSLog(@"handleNotification  scroll to bottom");
//    [self scrollToEnd:YES];
   
    
    CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height+100);
    [self setContentOffset:bottomOffset animated:YES];

//    [self scrollToOffset:CGPointMake(0, self.contentView.bounds.size.height+100) animated:YES];
}


%end


%hook NSData

- (NSData *)subdataWithRange:(NSRange)range {
    // 对range进行修改
    NSRange modifiedRange = NSMakeRange(range.location, range.length);
    NSLog(@"subdataWithRange %lu  %lu",range.location,range.length);
    
    
    // 调用原始函数
    NSData *originalData = %orig(modifiedRange);
   
    NSLog(@"Self: %@", [self performSelector:@selector(base64StringFromData:) withObject:self]);
    NSLog(@"originalData: %@", [self performSelector:@selector(base64StringFromData:) withObject:originalData]);
    return originalData;
}



%new
-(NSString *)base64StringFromData:(NSData *)data
{
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        // 字符集合
        
        static char encodingTable[100] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//        static char *encodingTable = malloc(strlen("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/") + 1);
//        strcpy(encodingTable, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");

        
        //
        static NSUInteger paddingTable[] = {0,2,1};
        //                 Table 1: The Base 64 Alphabet
        //
        //    Value Encoding  Value Encoding  Value Encoding  Value Encoding
        //        0 A            17 R            34 i            51 z
        //        1 B            18 S            35 j            52 0
        //        2 C            19 T            36 k            53 1
        //        3 D            20 U            37 l            54 2
        //        4 E            21 V            38 m            55 3
        //        5 F            22 W            39 n            56 4
        //        6 G            23 X            40 o            57 5
        //        7 H            24 Y            41 p            58 6
        //        8 I            25 Z            42 q            59 7
        //        9 J            26 a            43 r            60 8
        //       10 K            27 b            44 s            61 9
        //       11 L            28 c            45 t            62 +
        //       12 M            29 d            46 u            63 /
        //       13 N            30 e            47 v
        //       14 O            31 f            48 w         (pad) =
        //       15 P            32 g            49 x
        //       16 Q            33 h            50 y

        // 数据大小
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = dataLength / 3;
        if( (encodedBlocks + 1) >= (NSUIntegerMax / 4) ) return nil; // NSUInteger overflow check

        // 需要拼接的字符数，如：数据长度取余3为0，那么表示可以正处，不需要添加额外字符
        NSUInteger padding = paddingTable[dataLength % 3];

        // 如果需要添加字符存在，增加需要编码的数量
        if( padding > 0 ) encodedBlocks++;

        // 总的编码长度，因为根据编码可知，编码前的3字符变为编码后的4字符
        NSUInteger encodedLength = encodedBlocks * 4;

        // 分配内存大小
        void *ptr = malloc(encodedLength);
//        encodingBytes = malloc(encodedLength);
        encodingBytes = (unsigned char *)ptr;

        // 指针不为空
        if( encodingBytes != NULL ) {
            // 未编码之前的字节数
            NSUInteger rawBytesToProcess = dataLength;
            // 未编码之前的位置
            NSUInteger rawBaseIndex = 0;
            // 编码的位置
            NSUInteger encodingBaseIndex = 0;
            // 获取字节指针
            unsigned char *rawBytes = (unsigned char *)[data bytes];

            // 编码前的字节
            unsigned char rawByte1, rawByte2, rawByte3;
            // 循环遍历所有字符
            while( rawBytesToProcess >= 3 ) {
                // 获取3个字符
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];

                // 设置4个字符
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];

                // 修改位置，获取下一个三个字符
                rawBaseIndex += 3;
                // 设置接下来的4个字符
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
                    // we can skip rawByte3 since we have a partial block it would always be 0
                    break;
            }
            // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
            // if their value was 0 (cases 1-2).
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                // 添加=补齐4/3
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
%end
