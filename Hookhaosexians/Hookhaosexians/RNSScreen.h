//
//  RNSScreen.h
//  Hookhaosexians
//
//  Created by nantian on 2023/3/30.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#ifndef RNSScreen_h
#define RNSScreen_h



@interface RNSScreen : UIViewController
@property (nonatomic, strong) NSTimer *myTimer;
- (UIImage *)imageWithColor:(UIColor *)color;
@end

@interface RCTCustomScrollView : UIScrollView
-(void)setContentOffset:( CGPoint)arg2;
@end

@interface RCTScrollView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RCTCustomScrollView *scrollView;
-(void)scrollToEnd:(bool)arg2;
-(void)scrollToOffset:(CGPoint)arg2 animated:(bool)arg3;
@end


@interface AESUtils : NSObject

-(NSData *)baseDecrypt:(NSData *)arg2 key:(NSString *)arg3 cbcFlag:(bool)arg4 pos:(NSInteger)arg5;
@end
//@interface NSData : NSObject
// 
//-(NSString *)base64StringFromData:(NSData *)data;
//
//@end
//(void (NS_SWIFT_SENDABLE ^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
//typedef void (^RCTPromiseResolveBlock)(id errorblock,NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

typedef void (^RCTPromiseResolveBlock)(id result);

typedef void (^RCTPromiseRejectBlock)(NSString *code, NSString *message, NSError *error);
 

@interface RNServiceConnect : NSObject

/**
 [+] arg2 rnSendGetRequest: {
     p = "/app/video/detail-user-ex/incategory/fixed";
     s = vdbase;
 }
 [+] type: __NSDictionaryM
 [+] arg3 authorization: E5JqZ5MfwiZm12nCQRSF31IfayYTMhGGWqSJUfdFGHzM8K4cK2Z-QA03QoaQ7cS2Ql3czOqtK3RIMOqo0yzKJq5bsNvvD-lwchMwW6a-mmCVLV6_MiHzc8BouPiA7w5H
 [+] type: __NSCFString
 [+] arg4 data: {"category_id":"hwrjp4tgaj6x","start":54,"limit":18}
 [+] type: __NSCFString
 **/
//rnSendGetRequest:authorization:data:resolve:rejecter:
-(void) rnSendGetRequest:(NSDictionary *_Nullable)action authorization:(NSString *_Nullable)authorization data:(NSString *_Nullable)data resolve:(RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable)reject;
-(void)rnSendPostRequest:(NSDictionary *_Nullable)arg2 authorization:(NSString *_Nullable)arg3 data:(NSString *_Nullable)arg4 resolve:(RCTPromiseResolveBlock _Nullable)resolve rejecter:(RCTPromiseRejectBlock _Nullable)reject;

@end

@interface ServerConnectUtils : NSObject


/**
 [+] arg2 sendHttpPostAsync: https://g.pekingkeji.com
 [+] type: __NSCFString
 [+] arg3 path: {
     m = g;
     p = "/navbar/page";
     s = applayout;
 }
 [+] type: __NSDictionaryM
 [+] arg4 authorization: E5JqZ5MfwiZm12nCQRSF31IfayYTMhGGWqSJUfdFGHzM8K4cK2Z-QA03QoaQ7cS2Ql3czOqtK3RIMOqo0yzKJq5bsNvvD-lwchMwW6a-mmCVLV6_MiHzc8BouPiA7w5H
 [+] type: __NSCFString
 [+] arg5 data: {"navbar_id":"32zwcrdac1h"}
 [+] type: __NSCFString
 [+] arg6 callback: <__NSStackBlock__: 0x16c7be4f8>
 */
+(void)sendHttpPostAsync:(NSString * ) path path:(NSDictionary *) dict authorization:(NSString* )authString data:(NSString *)datastring callback:(id)arg6 errorCallback:(id)arg7;
  

@end
#endif /* RNSScreen_h */

