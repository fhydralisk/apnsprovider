//
//  NPApnsErrorPacket.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

//#import "NPPacket.h"
#import <NopqzipLib/NopqzipLib.h>

#define APNSEPH_COMMAND @"Command"
#define APNSEPH_STATUS  @"Status"
#define APNSEPH_ID      @"Identity"

#define APNSEP_COMMAND  8

@interface NPApnsErrorPacket : NPPacket

-(BOOL)endPacket;
+(NSArray *)headerFieldsDescription;
+(NSArray *)headerFieldsLength;

-(BOOL)endHeaders;

-(BOOL)autoEndHeaders;

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey;
-(id)getHeaderField:(NSString *)headerKey;

-(NSInteger)contentLengthToFill;
@end
