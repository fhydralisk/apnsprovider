//
//  NPApnsErrorPacket.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPApnsErrorPacket.h"


static NSArray *apnsErrorHeaderDescription, *apnsErrorHeaderLength;


@implementation NPApnsErrorPacket


+(void)initialize
{
    apnsErrorHeaderDescription=[NSArray arrayWithObjects:
                                APNSEPH_COMMAND,
                                APNSEPH_STATUS,
                                APNSEPH_ID,
                                nil];
    apnsErrorHeaderLength=[NSArray arrayWithObjects:
                           [NSNumber numberWithUnsignedInteger:1],
                           [NSNumber numberWithUnsignedInteger:1],
                           [NSNumber numberWithUnsignedInteger:4],  nil];
}


+(NSArray *)headerFieldsDescription
{
    return apnsErrorHeaderDescription;
}

+(NSArray *)headerFieldsLength
{
    return apnsErrorHeaderLength;
}

-(BOOL)endHeaders
{
    if ([[self getHeaderField:APNSEPH_COMMAND] unsignedCharValue]!=APNSEP_COMMAND) {
        return NO;
    }
    NSUInteger intStatus=[[self getHeaderField:APNSEPH_STATUS] unsignedIntegerValue];
    if (intStatus>10 && intStatus!=255) {
        return NO;
    }
    return [super endHeaders];
}

-(BOOL)autoEndHeaders
{
    if ([self setChar:APNSEP_COMMAND toField:APNSEPH_COMMAND]==NO) {
        return NO;
    }
    
    // set content length if needed;
    return [super autoEndHeaders];
}

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey
{
    NSNumber *number;
    if ([headerKey isEqualToString:APNSEPH_COMMAND]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if ([number unsignedIntegerValue]!=APNSEP_COMMAND) {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    /*if ([headerKey isEqualToString:APNSEPH_STATUS]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if ([number unsignedIntValue]>10 && [number unsignedIntegerValue]!=255) {
                return NO;
            }
        } else {
            return NO;
        }
    }*/
    
    
    
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
    
    if ([headerKey isEqualToString:APNSEPH_COMMAND] || [headerKey isEqualToString:APNSEPH_STATUS]) {
        return numberRet;
    }
    
    if ([headerKey isEqualToString:APNSEPH_ID]) {
        if (numberRet==nil) {
            return nil;
        }
        return [NSNumber numberWithLong:ntohl([numberRet unsignedIntValue])];
    }
    
    return [super getHeaderField:headerKey];
}


-(NSInteger)contentLengthToFill
{
    return 0;
}

-(BOOL)endPacket
{

    if ([self contentLengthFilled]==0) {
        return [super endPacket];
    }

    return NO;
}

@end