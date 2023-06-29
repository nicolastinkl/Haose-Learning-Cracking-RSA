//
//  AESUtils.m
//  IJKMediaDemo
//
//  Created by nantian on 2023/3/24.
//  Copyright © 2023 bilibili. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>


#import "AESUtils.h"

@implementation AESUtils

-(NSData *)GetRandomIvCode {
    uint8_t iv[16];
    for (int i = 0; i < 16; i++) {
        iv[i] = arc4random();
    }
    return [NSData dataWithBytes:iv length:16];
}
- (NSData *)encrypt:(NSData *)decryptedData key:(NSString *)key{
    AESUtils *aesUtils = [[AESUtils alloc] init];
    return [aesUtils baseEncrypt:decryptedData key:key cbcFlag:NO pos:0];
}

- (NSData *)decrypt:(NSData *)encryptedData key:(NSString *)key{
    AESUtils *aesUtils = [[AESUtils alloc] init];
    return [aesUtils baseDecrypt:encryptedData key:key cbcFlag:NO pos:0];
}


 //-(void *)baseEncrypt:(void *)arg2 key:(void *)arg3 cbcFlag:(bool)arg4 pos:(long long)arg5 {
- (NSData *)baseEncrypt:(NSData *)data key:(NSString *)key cbcFlag:(BOOL)cbcFlag pos:(NSInteger)pos {
    NSMutableData *result = [NSMutableData data];
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:0];
    size_t keyLength = kCCKeySizeAES128;
    unsigned char iv[kCCBlockSizeAES128];
    if (cbcFlag) {
        if (SecRandomCopyBytes(kSecRandomDefault, sizeof(iv), iv) != 0) {
            return nil;
        }
        [result appendBytes:iv length:sizeof(iv)];
    }
    else {
        NSData * ivsssrandom = [self GetRandomIvCode];
//        unsigned char * str = (unsigned char *)[ivsssrandom bytes];
        //void    *memcpy(void *__dst, const void *__src, size_t __n);
        memcpy(iv, [ivsssrandom bytes],  sizeof(ivsssrandom.bytes));
        
//        ivsssrandom.bytes
//        void    *memset(void *__b, int __c, size_t __len);
//        memset(ivsssrandom.bytes, 0, sizeof(ivsssrandom.bytes));
    }
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t encryptedSize = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                      keyData.bytes, keyLength, iv,
                                      data.bytes, data.length, buffer, bufferSize, &encryptedSize);
    if (status == kCCSuccess) {
        
        [result appendBytes:buffer length:encryptedSize];
        [result appendBytes:iv length:sizeof(iv)];
        free(buffer);
        return result;
    }
    else {
        free(buffer);
        return nil;
    }
}

- (NSData *)baseDecrypt:(NSData *)data key:(NSString *)key cbcFlag:(BOOL)cbcFlag pos:(NSInteger)pos{
   
    NSUInteger length = [data length];
    const void *bytes = [data bytes];
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:0];

    NSUInteger subLength = pos;
    if (cbcFlag) {
      subLength = MIN(pos, length);
    }
    
    NSData *resultData = nil;
    unsigned char iv[kCCBlockSizeAES128];
    if (cbcFlag) {
//        NSData * newdata  = [data getBytes:bytes length:length];
        NSData *  ivnewdata2  = [data subdataWithRange:NSMakeRange(0, kCCBlockSizeAES128)];
        memcpy(iv, [ivnewdata2 bytes],  sizeof(ivnewdata2.bytes));
        NSUInteger bufferSize = length + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
       
        memset(buffer, 0x00, bufferSize);

        size_t bytesEncrypted = 0;

        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding , [keyData bytes], kCCKeySizeAES128, iv, bytes, length, buffer, bufferSize, &bytesEncrypted);
 
 
        if (cryptStatus == kCCSuccess) {
          resultData = [NSData dataWithBytesNoCopy:buffer length:bytesEncrypted];
        } else {
          free(buffer);
        }
    }else{
        NSUInteger bufferSize = length + kCCBlockSizeAES128;
        void *buffer = malloc(bufferSize);
      
        memset(buffer, 0x00, bufferSize);

        size_t bytesEncrypted = 0;

        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 3, [keyData bytes], kCCKeySizeAES128, iv, bytes, length, buffer, bufferSize, &bytesEncrypted);
 

        if (cryptStatus == kCCSuccess) {
          resultData = [NSData dataWithBytesNoCopy:buffer length:bytesEncrypted];
        } else {
          free(buffer);
        }
    }
//    NSData *subData = [data subdataWithRange:NSMakeRange(0, subLength)];
//    NSUInteger ivLength = kCCBlockSizeAES128;
//    void *iv = malloc(ivLength);
//    if (!iv) {
//      return nil;
//    }
//    memset(iv, 0x00, ivLength);

    

    return resultData;
}
@end
