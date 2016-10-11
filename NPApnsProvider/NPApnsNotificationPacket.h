//
//  NPApnsNotificationPacket.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <NopqzipLib/NopqzipLib.h>

#define APNSPH_COMMAND @"Command"
#define APNSPH_CONTENTLENGTH @"Content Length"

#define APNSP_COMMAND 2

@interface NPApnsNotificationPacket : NPPacket

-(BOOL)endPacket;


+(NSArray *)headerFieldsDescription;
+(NSArray *)headerFieldsLength;

-(BOOL)autoEndHeaders;

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey;
-(id)getHeaderField:(NSString *)headerKey;

-(NSInteger)contentLengthToFill;





@end