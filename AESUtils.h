//
//  AESUtils.h
//  IJKMediaDemo
//
//  Created by nantian on 2023/3/24.
//  Copyright © 2023 bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AESUtils : NSObject
-(NSData *)GetRandomIvCode;

- (NSData *)encrypt:(NSData *)decryptedData key:(NSString *)key;
- (NSData *)decrypt:(NSData *)encryptedData key:(NSString *)key;

- (NSData *)baseDecrypt:(NSData *)data key:(NSString *)key cbcFlag:(BOOL)cbcFlag pos:(NSInteger)pos;
- (NSData *)baseEncrypt:(NSData *)data key:(NSString *)key cbcFlag:(BOOL)cbcFlag pos:(NSInteger)pos;



@end

NS_ASSUME_NONNULL_END
