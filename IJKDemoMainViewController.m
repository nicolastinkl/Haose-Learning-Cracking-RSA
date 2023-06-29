/*
 * Copyright (C) 2015 Gdier
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "IJKDemoMainViewController.h"
#import "IJKDemoInputURLViewController.h"
#import "IJKQRCodeScanViewController.h"
#import "IJKCommon.h"
#import "IJKDemoHistory.h"
#import "IJKMoviePlayerViewController.h"
#import "IJKDemoLocalFolderViewController.h"
#import "IJKDemoSampleViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "AESUtils.h"
#import "IJKPlayer.h"

@interface IJKDemoMainViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *tableViewCellTitles;
@property(nonatomic,strong) NSArray *historyList;

@end

@implementation IJKDemoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Main";
//    self.tableView.backgroundColor = UIColor.blackColor;
    
    self.tableViewCellTitles = @[ @"testjiemi",
                                 @"Local Folder",
                                 @"Movie Picker",
                                 @"Input URL",
                                 @"Scan QRCode",
                                 @"Online Samples",
                                 
                                 ];
    
   
    
}

-(void)downloadFile:(NSString * ) urlStr {

    //1.创建url
    NSString *filename = [urlStr componentsSeparatedByString:@"/"].lastObject;
//    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    //2.创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

    //3.创建会话（这里使用了一个全局会话）并且启动任务
    NSURLSession *session=[NSURLSession sharedSession];

    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            //注意location是下载后的临时保存路径,需要将它移动到需要保存的位置
            
            NSError *saveError;
            
            NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath=[cachePath stringByAppendingPathComponent:filename];
            NSLog(@"%@",savePath);
            NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
            //先删除老文件
            [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            if (!saveError) {
                NSLog(@"save sucess.");
            }else{
                NSLog(@"error is :%@",saveError.localizedDescription);
            }
            // /var/mobile/Containers/Data/Application/2B53EAFD-635A-4C75-8FA3-D5FD89CFCED9/Documents/
            
            //进行解密
            NSData * encryptoFile =  [NSData dataWithContentsOfFile:savePath];
            NSLog(@"加密文件大小：%lu",(unsigned long)encryptoFile.length);
            NSString * key = @"";
            if ([filename containsString:@".m3u8"] || [filename containsString:@".ts"]) {
                key= @"TwtsEgjErnXRwOo1ofUQ2g==";
            }else if ([filename containsString:@".jpg"] || [filename containsString:@".jpeg"] || [filename containsString:@".webm"] || [filename containsString:@".webp"]) {
                key= @"1V6WW9fMB2MAPOVOD2DRfw==";
            }
            NSData * descryptoFile =  [[AESUtils alloc] decrypt:encryptoFile key:key];
            if (descryptoFile == nil) {
                return;
            }
            NSString *str2 = [[NSString alloc] initWithData:descryptoFile encoding:NSUTF8StringEncoding];
            NSLog(@"解密文件NSData：  %@",descryptoFile);
            NSLog(@"解密文件NSString：  %@",str2);
            NSString * r24 = [NSString stringWithFormat:@"%@/new%@",cachePath,filename];
            [[NSFileManager defaultManager] removeItemAtPath:str2 error:nil];
            if(str2){
                 [str2 writeToFile:r24 atomically:0x1 encoding:0x4 error:nil];
            }else{
                //TS 文件
                [descryptoFile writeToFile:r24 atomically:YES];
            }
            
            
            
            
            
            [self shareFileWithURL:[NSURL fileURLWithPath:r24]];
            
//            str2  r0 = [r24 writeFileToLocalFileUrl:r25 downloadName:r26 contentStr:r27 aesKey:*(r22 + 0x20)];

//            NSString *Str2=[NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:nil];
            

        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
    }];

    [downloadTask resume];
}


- (void)shareFileWithURL:(NSURL *)fileURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 创建分享活动视图控制器
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];

        // 设置视图控制器的属性
        activityVC.popoverPresentationController.sourceView = self.view;

        // 显示分享视图控制器
        [self presentViewController:activityVC animated:YES completion:nil];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.historyList = [[IJKDemoHistory instance] list];

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Open from";
            
        case 1:
            return @"History";
            
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (IOS_NEWER_OR_EQUAL_TO_7) {
                return self.tableViewCellTitles.count;
            } else {
                return self.tableViewCellTitles.count - 1;
            }
            
        case 1:
            return self.historyList.count;
            
        default:
            return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.tableViewCellTitles[indexPath.row];
            
            break;
            
        case 1:
            cell.textLabel.text = [self.historyList[indexPath.row] title];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void) testjiemi{
    NSURL *documentsUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    NSError *error = nil;
    
    [documentsUrl setResourceValue:[NSNumber numberWithBool:YES]
                            forKey:NSURLIsExcludedFromBackupKey
                             error:&error];
    
    
    //download m3u8
    /**
     
     [返回值] __NSCFStringretval: https://w1.zikl.xyz/cos/txvideo/xkzx2yacn5n/ts/e3c02ad0a4c5d96ef05c96937559b322.m3u8
     [+] type: __NSCFString
     *** exited +[DADownloadUrlResolver analysisURL:localUrl:downloadName:aesKey:finishBlock:]
     [-] ---------------------------------------------------------------

     Tracing +[AESUtils decrypt:key:]
     [+] ---------------------------------------------------------------
     *** entering +[AESUtils decrypt:key:]
     [+] 参数为NSData 不显示
     [+] type: OS_dispatch_data
     [+] arg3 key: TwtsEgjErnXRwOo1ofUQ2g==
     [+] type: __NSCFString
     [+] 类 args[0]: AESUtils
     [+] type: AESUtils
     
     */
    
    //
    NSLog(@"========心跳解密测试===========");
    {
//        NSString *jsonmiwen =@"mnmnmn";
//        NSLog(@"密文：%@",jsonmiwen);
//        NSString * key = @"qq0g6Jp2JfOHKv78q64M7w==";
//    //    NSString *json = @"{\"userid\":\"4yw3ja\",\"category_id\":\"vadk6icyp5c\",\"for_user\":true,\"limit\":12}";
//        NSData * jiami = [[AESUtils alloc] encryptWithCBC:[jsonmiwen dataUsingEncoding:(NSUTF8StringEncoding)] key:key];
//        NSLog(@"加密后：%@",[self base64StringFromData:jiami]);

//        key = @"KWxyWZjXSjScGfp9BCrmHQ==";
//        NSString * otherapp = @"pQFHAFSF2Zk+1b9XgyQ6UK/a53l+eF3o5XQ5/XDh1OwzVHb2AS3bER2qY0c60iHTsqJEpxuh6Cyfc4JUrxZ+yR0s8RFO539R5aBZ370nk7Q=";
        
        
        NSString *  key = @"KWxyWZjXSjScGfp9BCrmHQ==";
        NSString * otherapp = @"Pgqb/Oa4n6JbRlYBUHL8rtAbm3D/dqym0qeXvS0jwD3PAGJ410Upqla5dKFoClVxyO9v3MT29qCZWQsrEyPs+FCkFUCIMKso9ytSqFreZyq1CpPa+8bts6QLRo91OMN6ID2UaSpl81vjkj6kLQ9OEnU3GDTPAC9/7RlbukSPdEblk7UDkUG251uNXs/InBv5Lrq9jILo8cj8gOqTn1DfYRKp0dLpojSOPwgBD2AjYEyXaUu25CcElyu6SO63fINVMqoA0uNMOhW/qXK3VJFjWtER7iID3NVwf3f9qION11H0Q6SeOJ53rYlLlAEAJPfADpYDG8Pz/3E1zjpKT+Z2Dr7uFvrA+6cgis1MHFAVZ7jI0gJGCowVFKXE7/v+uJ4wwReZ0D2J4m6tFhUOIlLMUQ6fnAK3xd4FoW6oFVmby6IKJq/W9vNMQrVqVv4p5qDB5lga46+LWG4ckuo3JdNJCQ==";
        NSLog(@"otherapp：%@",otherapp);
        
        NSData *jimiehou = [[AESUtils alloc] decryptWithCBC:[[NSData alloc] initWithBase64EncodedString:otherapp options:0] key:key];
        NSString *str2 = [[NSString alloc] initWithData:jimiehou encoding:NSUTF8StringEncoding];

        NSLog(@"解密后：%@",str2);
    }
    
    NSLog(@"========图片类型加密解密测试===========");
    /*
    {
        NSString *jsonmiwen =@"tupmiwen";
        NSLog(@"图片密文：%@",jsonmiwen);
        NSString * key = @"1V6WW9fMB2MAPOVOD2DRfw==";
        NSData * picjiamidata =  [[AESUtils alloc]  encrypt:[jsonmiwen dataUsingEncoding:4] key:key];
        NSLog(@"picjiamidata: %@",[self base64StringFromData:picjiamidata]);
        NSData *jimiehou = [[AESUtils alloc] decrypt:picjiamidata key:key];
        NSString *str2 = [[NSString alloc] initWithData:jimiehou encoding:NSUTF8StringEncoding];

        NSLog(@" picjiamidata解密后：%@",str2);
    }
    */
    
    
    
    //解密m3u8和ts文件
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self downloadFile:@"https://w1.zikl.xyz/cos/txvideo/xkzx2yacn5n/ts/e3c02ad0a4c5d96ef05c96937559b322.m3u8"];
//        [self downloadFile:@"https://git.qiyezhushou.com.cn/cos/txvideo-new/scraper/bbb/mp4-720p/ts/ts1678735414/bf37112b6af1be60e5bfc47b952bdc9c_0059.ts"];
       
//        [self downloadFile:@"https://git.qiyezhushou.com.cn/cos/txvideo-new/scraper/bbb/mp4-720p/ts/ts1678735414/bf37112b6af1be60e5bfc47b952bdc9c_0718.ts"];
    });
    
    
    //解密jpg和webp
    //https://hot.voaensf.cn/view2/i3/tximg-new/default/2023-01-10/13ea83fee56617bca6b426575deb3d83.jpeg
    //https://git.qiyezhushou.com.cn/cos/txvideo-new/scraper/bbb/webm/2296ffc8e3d48ae80136ccb5637cffd9.webm
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self downloadFile:@"https://res.ningxingnamo.cn/view2/i3/tximg/actor/p6w0hzs29vb/e53194c14000bfa9162a3b757939efb8.jpg "];
        
    });
//    UIView * playerView =  [[UIView alloc] initWithFrame:self.view.frame];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [self testjiemi];
//                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//
//                    IJKDemoLocalFolderViewController *viewController = [[IJKDemoLocalFolderViewController alloc] initWithFolderPath:documentsPath];
//
//                    [self.navigationController pushViewController:viewController animated:YES];
                } break;

                case 1:
                    [self startMediaBrowserFromViewController: self
                                                usingDelegate: self];
                    break;

                case 2:
                    [self.navigationController pushViewController:[[IJKDemoInputURLViewController alloc] init] animated:YES];
                    break;

                case 3:
                    [self.navigationController pushViewController:[[IJKQRCodeScanViewController alloc] init] animated:YES];
                    break;

                case 4:
                    [self.navigationController pushViewController:[[IJKDemoSampleViewController alloc] init] animated:YES];
                    break;

                default:
                    break;
            }
        } break;
            
        case 1: {
            IJKDemoHistoryItem *historyItem = self.historyList[indexPath.row];
            
            [IJKVideoViewController presentFromViewController:self withTitle:historyItem.title URL:historyItem.url completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
        } break;
            
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }

    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && editingStyle == UITableViewCellEditingStyleDelete) {
        [[IJKDemoHistory instance] removeAtIndex:indexPath.row];
        self.historyList = [[IJKDemoHistory instance] list];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSURL *movieUrl;

    // Handle a movied picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {

        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        movieUrl = [NSURL URLWithString:moviePath];
    }

    [self dismissViewControllerAnimated:YES completion:^(void){
        [self.navigationController pushViewController:[[IJKVideoViewController alloc]   initWithURL:movieUrl] animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark misc

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {

    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;

    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];

    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;

    mediaUI.delegate = delegate;

    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

-(NSString *)base64StringFromData:(NSData *)data
{
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        // 字符集合
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
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
        encodingBytes = malloc(encodedLength);
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
@end
