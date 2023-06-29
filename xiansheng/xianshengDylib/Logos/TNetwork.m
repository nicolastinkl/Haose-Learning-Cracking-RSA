//
//  TNetwork.m
//  States
//
//  Created by tinkl on 10/19/16.
//
//

#import "TNetwork.h"
#import <objc/runtime.h>

@implementation TNetwork

+ (instancetype)sharedManager{
     static TNetwork *sharedAccountManagerInstance = nil;  
        static dispatch_once_t predicate;  
        dispatch_once(&predicate, ^{  
                sharedAccountManagerInstance = [[self alloc] init];   
        });  
    return sharedAccountManagerInstance;  
}

+ (NSURLRequest *)HTTPGETRequestForURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSString * s = [self performSelector:@selector(HTTPBodyWithParameters:) withObject:parameters];
    NSString *URLFellowString = [@"?"stringByAppendingString:s];
    
    NSString *finalURLString = [[url.absoluteString stringByAppendingString:URLFellowString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *finalURL = [NSURL URLWithString:finalURLString];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [URLRequest setHTTPMethod:@"GET"];
    
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return URLRequest;
}



+ (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}


+ (void) POSTRequestJSON:(NSString *)Url RequestParamsString:(NSString *) stringparams FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *requst=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    requst.timeoutInterval=15.0;//设置请求超时为5秒
    requst.HTTPMethod=@"POST";//设置请求方法
  // NSString * s = [self performSelector:@selector(HTTPBodyWithParameters:) withObject:parameters];
   //把拼接后的字符串转换为data，设置请求体
    [requst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *jsonData = [stringparams dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    id json = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];

    requst.HTTPBody = jsonData;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue currentQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if(error){
             //有错误
            block(response,nil,error);
         }else{
            block(response,data,error);
         }
        NSLog(@"error : %@",error);
    }];
    
    [task resume];
    
}

+ (void) POSTRequestJSON:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *requst=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    requst.timeoutInterval=15.0;//设置请求超时为5秒
    requst.HTTPMethod=@"POST";//设置请求方法
  // NSString * s = [self performSelector:@selector(HTTPBodyWithParameters:) withObject:parameters];
   //把拼接后的字符串转换为data，设置请求体
    [requst setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    id json = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

    requst.HTTPBody = json;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue currentQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if(error){
             //有错误
            block(response,nil,error);
         }else{
            block(response,data,error);
         }
        NSLog(@"error : %@",error);
    }];
    
    [task resume];
    
}

+ (void) POSTRequest:(NSString *)Url RequestParams:(NSString *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    NSURL *URL = [NSURL URLWithString:Url];
    
      NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
      request.timeoutInterval=15.0;//设置请求超时为5秒
     request.HTTPMethod=@"POST";//设置请求方法
    // NSString * s = [self performSelector:@selector(HTTPBodyWithParameters:) withObject:parameters];
     //把拼接后的字符串转换为data，设置请求体
     request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
     //创建一个新的队列（开启新线程）
    NSOperationQueue *queue = [NSOperationQueue new];
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:block];

}


+ (void) POSTNew1111Request:(NSString *)Url RequestParams:(NSString *)params FinishBlock:(CompletioBlock) block{

    // NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    // NSLog(@"sysVersion  1 : %.1f",[sysVersion doubleValue]);

        // >= iOS 10.0
         
    NSMutableURLRequest * requst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]];
    //延时时间
    requst.timeoutInterval = 30;
    //请求方式
    requst.HTTPMethod = @"POST";
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    //请求体
    requst.HTTPBody = data;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue currentQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if(error){
             //有错误
            block(response,nil,error);
         }else{
            block(response,data,error);
         }
        NSLog(@"error : %@",error);
    }];
    
    [task resume];

   
        // < iOS 10.0
   //     [TNetwork POSTRequest:Url RequestParams:params  FinishBlock:block];
      

    

}
/*
//代理实现类
 
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //证书的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //网络请求证书
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) { //受信任的
       //获取服务器返回的证书
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
} 
*/

+ (void) GETRequest:(NSString *)Url  FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    NSURL *url = [NSURL URLWithString:Url];
    
    //NSURLRequest *  request = [self HTTPGETRequestForURL:url parameters:params]; 
    
    NSURL *finalURL = [NSURL URLWithString:Url];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:finalURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [URLRequest setHTTPMethod:@"GET"];
    
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //创建一个新的队列（开启新线程）
    NSOperationQueue *queue = [NSOperationQueue new];
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:URLRequest
                                       queue:queue
                           completionHandler:block];
}


+ (void) GETRequest:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    NSURL *url = [NSURL URLWithString:Url];
    
    NSURLRequest *  request = [self HTTPGETRequestForURL:url parameters:params];
    //创建一个新的队列（开启新线程）
    NSOperationQueue *queue = [NSOperationQueue new];
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:block];
    
}




/**
 *  get请求
 */
// 将网络数读取为字符串
+ (NSString *)bsy_getDataByURL:(NSString *) url {
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] encoding:NSUTF8StringEncoding];
}


@end




@implementation NSArray (Safe)+ (void)load {    Method originalMethod = class_getClassMethod(self, @selector(arrayWithObjects:count:));    Method swizzledMethod = class_getClassMethod(self, @selector(na_arrayWithObjects:count:));    method_exchangeImplementations(originalMethod, swizzledMethod);}+ (instancetype)na_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {    id nObjects[cnt];    int i=0, j=0;    for (; i<cnt && j<cnt; i++) {        if (objects[i]) {            nObjects[j] = objects[i];            j++;        }    }    return [self na_arrayWithObjects:nObjects count:j];}@end@implementation NSMutableArray (Safe)+ (void)load {    Class arrayCls = NSClassFromString(@"__NSArrayM");    Method originalMethod1 = class_getInstanceMethod(arrayCls, @selector(insertObject:atIndex:));    Method swizzledMethod1 = class_getInstanceMethod(arrayCls, @selector(na_insertObject:atIndex:));    method_exchangeImplementations(originalMethod1, swizzledMethod1);    Method originalMethod2 = class_getInstanceMethod(arrayCls, @selector(setObject:atIndex:));    Method swizzledMethod2 = class_getInstanceMethod(arrayCls, @selector(na_setObject:atIndex:));    method_exchangeImplementations(originalMethod2, swizzledMethod2);}- (void)na_insertObject:(id)anObject atIndex:(NSUInteger)index {    if (!anObject)        return;    [self na_insertObject:anObject atIndex:index];}- (void)na_setObject:(id)anObject atIndex:(NSUInteger)index {    if (!anObject)        return;    [self na_setObject:anObject atIndex:index];}
@end



/*
@implementation DynamicUIWebViewDelegateHook
#pragma mark - UIWebViewDelegate  
// webView Delegate Method

- (void)replaced_webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"tweak : Hook [UIWebView replaced_webViewDidStartLoad:]");
    //(c)中的5.6步省略的话,调用这步将会死循环!!!
    [self replaced_webViewDidStartLoad:webView];
}

- (void)replaced_webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"tweak : Hook [UIWebView replaced_webViewDidFinishLoad:]");

    [self replaced_webViewDidFinishLoad:webView];
}


-(void)replaced_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"tweak : Hook [UIWebView didFailLoadWithError:]");

    [self replaced_webView: webView didFailLoadWithError:error];
}

-(BOOL)replaced_webView:(UIWebView *)webView  shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"tweak : Hook [UIWebView shouldStartLoadWithRequest: ] %@",request);

   return [self replaced_webView: webView shouldStartLoadWithRequest:request navigationType:navigationType];
}


// 剩下省略...

+ (void)enableHookUIWebViewDelegateMethod:(Class)aClass
{
    exchangeMethod(aClass, @selector(webViewDidStartLoad:), [self class], @selector(replaced_webViewDidStartLoad:));
    exchangeMethod(aClass, @selector(webViewDidFinishLoad:), [self class], @selector(replaced_webViewDidFinishLoad:));
   exchangeMethod(aClass, @selector(webView:didFailLoadWithError:), [self class], @selector(replaced_webView:didFailLoadWithError:));
    exchangeMethod(aClass, @selector(webView:shouldStartLoadWithRequest:navigationType:), [self class], @selector(replaced_webView:shouldStartLoadWithRequest:navigationType:));
}

void exchangeMethod(Class originalClass, SEL original_SEL, Class replacedClass, SEL replaced_SEL)
{
    // 1.这里是为了防止App中多次(偶数次)调用setDelegete时,导致后面的IMP替换又回到没替换之前的结果了!(这步是猜测,没来急在sample中测试)
    static NSMutableArray * classList =nil;
    if (classList == nil) {
        classList = [[NSMutableArray alloc] init];
    }
    NSString * className = [NSString stringWithFormat:@"%@__%@", NSStringFromClass(originalClass), NSStringFromSelector(original_SEL)];
    for (NSString * item in classList) {
        if ([className isEqualToString:item]) {
            NSLog(@"tweak : setDelegate 2nd for (%@)==> return!", className);
            return;
        }
    }
    NSLog(@"tweak : setDelegate 1st for (%@)==> return!", className);
    [classList addObject:className];
    
    // 2.原delegate 方法
    Method originalMethod = class_getInstanceMethod(originalClass, original_SEL);
    assert(originalMethod);
    //IMP originalMethodIMP = method_getImplementation(originalMethod);
    
    // 3.新delegate 方法
    Method replacedMethod = class_getInstanceMethod(replacedClass, replaced_SEL);
    assert(replacedMethod);
    IMP replacedMethodIMP = method_getImplementation(replacedMethod);
    
    // 4.先向实现delegate的classB添加新的方法
    if (!class_addMethod(originalClass, replaced_SEL, replacedMethodIMP, method_getTypeEncoding(replacedMethod))) {
        NSLog(@"tweak : class_addMethod ====> Error! (replaced_SEL)");
    }
    else
    {
        NSLog(@"tweak : class_addMethod ====> OK! (replaced_SEL)");
    }
    
    // 5.重新拿到添加被添加的method,这部是关键(注意这里originalClass, 不replacedClass)
    Method newMethod = class_getInstanceMethod(originalClass, replaced_SEL);
    //IMP newMethodIMP = method_getImplementation(newMethod);
    
    // 6.正式交换这两个函数指针的实现
    method_exchangeImplementations(originalMethod, newMethod);
    
    // 7.如果把第6步换成下面的方法,或者去掉5.6两步直接用下面的方法试试,有惊喜~
    //method_exchangeImplementations(originalMethod, replacedMethod);
    
}

@end
*/
