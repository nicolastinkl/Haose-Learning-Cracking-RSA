//
//  TNetwork.h
//  States
//
//  Created by tinkl on 10/19/16.
//
//

#import <Foundation/Foundation.h>

typedef void (^CompletioBlock)(NSURLResponse *response, NSData *dict, NSError *error);

//
@interface TNetwork : NSObject

+ (instancetype)sharedManager;

+ (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters;
+ (NSURLRequest *)HTTPGETRequestForURL:(NSURL *)url parameters:(NSDictionary *)parameters;

+ (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters;

+ (void) GETRequest:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;


+ (void) GETRequest:(NSString *)Url  FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;


+ (void) POSTRequestJSON:(NSString *)Url RequestParamsString:(NSString *) stringparams FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;

+ (void) POSTRequestJSON:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;

//加密请求
+ (void) POSTRequest:(NSString *)Url RequestParams:(NSString *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;


//加密请求11
 + (void) POSTNew1111Request:(NSString *)Url RequestParams:(NSString *)params FinishBlock:(CompletioBlock) block;

+(NSString *)bsy_getDataByURL:(NSString *) url;

@end


// @interface DynamicUIWebViewDelegateHook : NSObject

// - (void)replaced_webViewDidStartLoad:(UIWebView *)webView;

// - (void)replaced_webViewDidFinishLoad:(UIWebView *)webView;
// -(void)replaced_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
// + (void)enableHookUIWebViewDelegateMethod:(Class)aClass;
// -(BOOL)replaced_webView:(UIWebView *)webView  shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

// @end
