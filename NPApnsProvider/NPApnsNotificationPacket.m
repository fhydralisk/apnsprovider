//
//  NPApnsNotificationPacket.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPApnsNotificationPacket.h"

static NSArray *apnsHeaderDescription, *apnsHeaderLength;

@implementation NPApnsNotificationPacket

+(void)initialize
{
    apnsHeaderDescription=[NSArray arrayWithObjects:
                           APNSPH_COMMAND,
                           APNSPH_CONTENTLENGTH, nil];
    apnsHeaderLength=[NSArray arrayWithObjects:
                      [NSNumber numberWithUnsignedInteger:1],
                      [NSNumber numberWithUnsignedInteger:4], nil];
}


+(NSArray *)headerFieldsDescription
{
    return apnsHeaderDescription;
}

+(NSArray *)headerFieldsLength
{
    return apnsHeaderLength;
}

-(BOOL)autoEndHeaders
{
    if ([self setChar:APNSP_COMMAND toField:APNSPH_COMMAND]==NO) {
        return NO;
    }
    
    // set content length if needed;
    if ([self getHeaderField:APNSPH_CONTENTLENGTH]==nil) {
        if ([self content]) {
            [self setLong:(UInt32)[self contentLengthFilled] toField:APNSPH_CONTENTLENGTH byNetOrder:YES];
        } else {
            return NO;
        }
    }
    return [super autoEndHeaders];
}

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey
{
    NSNumber *number;
    if ([headerKey isEqualToString:APNSPH_COMMAND]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if ([number unsignedIntegerValue]!=APNSP_COMMAND) {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    if ([headerKey isEqualToString:APNSPH_CONTENTLENGTH]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if (ntohl([number unsignedIntValue])==0) {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    
    return [super canSetData:headerData toField:headerKey];
}

-(id)getHeaderField:(NSString *)headerKey
{
    //NSNumber *ret;
    NSData *data=[self getHeaderFieldData:headerKey];
    
    if (data==nil) {
        return nil;
    }
    
    
    NSNumber *numberRet=nil;
    [NPPacket convertData:data ToNumber:&numberRet];
    
    if ([headerKey isEqualToString:APNSPH_COMMAND]) {
        return numberRet;
    }
    
    if ([headerKey isEqualToString:APNSPH_CONTENTLENGTH]) {
        if (numberRet==nil) {
            return nil;
        }
        return [NSNumber numberWithLong:ntohl([numberRet unsignedIntValue])];
    }
    
    return [super getHeaderField:headerKey];
}


-(NSInteger)contentLengthToFill
{
    NSNumber *contentLen=[self getHeaderField:APNSPH_CONTENTLENGTH];
    if (contentLen) {
        return [contentLen unsignedIntValue];
    }
    
    return NP_FILLRESULT_NEEDMORE;
}

-(BOOL)endPacket
{
    NSNumber *contentLen=[self getHeaderField:APNSPH_CONTENTLENGTH];
    if (contentLen==nil) {
        return NO;
    }
    
    
    if ([self contentLengthFilled]!=[contentLen unsignedIntValue]) {
        return NO;
    }
    
    return [super endPacket];
}


@end
