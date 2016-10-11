//
//  NPTokenPacket.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <NopqzipLib/NopqzipLib.h>
#define TKPH_TOKEN @"Token"
#define TKPH_LENGTH_TOKEN 32

@interface NPTokenPacket : NPPacket
-(BOOL)endPacket;
+(NSArray *)headerFieldsDescription;
+(NSArray *)headerFieldsLength;

-(BOOL)endHeaders;

-(BOOL)autoEndHeaders;

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey;
-(id)getHeaderField:(NSString *)headerKey;

-(NSInteger)contentLengthToFill;

@end
