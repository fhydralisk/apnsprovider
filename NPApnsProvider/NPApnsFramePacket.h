//
//  NPApnsFramePacket.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <NopqzipLib/NopqzipLib.h>

#define APNSFPH_TYPE            @"Type"
#define APNSFPH_CONTENTLENGTH   @"Content Length"

#define APNSFPTYPE_DEVICETOCKEN     1
#define APNSFPTYPE_PAYLOAD          2
#define APNSFPTYPE_NOTIFICATIONID   3
#define APNSFPTYPE_EXPIRATION       4
#define APNSFPTYPE_PRIORITY         5
#define APNSFPTYPE_MAXVALUE         5   //indecates the max value of type indifier;


#define APNSFLENGTH_DEVICETOCKEN     32
//#define APNSFLENGTH_PAYLOAD          2
#define APNSFLENGTH_NOTIFICATIONID   4
#define APNSFLENGTH_EXPIRATION       4
#define APNSFLENGTH_PRIORITY         1


@interface NPApnsFramePacket : NPPacket

-(BOOL)endPacket;


+(NSArray *)headerFieldsDescription;
+(NSArray *)headerFieldsLength;

-(BOOL)endHeaders;

-(BOOL)autoEndHeaders;

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey;
-(id)getHeaderField:(NSString *)headerKey;

-(NSInteger)contentLengthToFill;



@end
