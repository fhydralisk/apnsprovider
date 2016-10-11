//
//  NPApnsFramePacket.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPApnsFramePacket.h"

static NSArray *apnsFrameHeaderDescription, *apnsFrameHeaderLength;

@implementation NPApnsFramePacket
+(void)initialize
{
    apnsFrameHeaderDescription=[NSArray arrayWithObjects:
                           APNSFPH_TYPE,
                           APNSFPH_CONTENTLENGTH, nil];
    apnsFrameHeaderLength=[NSArray arrayWithObjects:
                      [NSNumber numberWithUnsignedInteger:1],
                      [NSNumber numberWithUnsignedInteger:2], nil];
}


+(NSArray *)headerFieldsDescription
{
    return apnsFrameHeaderDescription;
}

+(NSArray *)headerFieldsLength
{
    return apnsFrameHeaderLength;
}

-(BOOL)endHeaders
{
    NSNumber *numType=[self getHeaderField:APNSFPH_TYPE];
    NSNumber *numLength=[self getHeaderField:APNSFPH_CONTENTLENGTH];
    
    if (numType==nil || numLength==nil) {
        return NO;
    }
    
    switch ([numType unsignedCharValue]) {
        case APNSFPTYPE_DEVICETOCKEN:
            if ([numLength unsignedShortValue]!=APNSFLENGTH_DEVICETOCKEN) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_NOTIFICATIONID:
            if ([numLength unsignedShortValue]!=APNSFLENGTH_NOTIFICATIONID) {
                return NO;
            }
            break;

        case APNSFPTYPE_EXPIRATION:
            if ([numLength unsignedShortValue]!=APNSFLENGTH_EXPIRATION) {
                return NO;
            }
            break;
        
        case APNSFPTYPE_PRIORITY:
            if ([numLength unsignedShortValue]!=APNSFLENGTH_PRIORITY) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_PAYLOAD:
            if ([numLength unsignedShortValue]==0) {
                return NO;
            }
            break;
            
        default:
            return NO;
            break;
    }
    return [super endHeaders];
}

-(BOOL)autoEndHeaders
{
    NSNumber *numType=[self getHeaderField:APNSFPH_TYPE];
    //NSNumber *numLength=[self getHeaderField:APNSFPH_CONTENTLENGTH];
    
    if (numType==nil) {
        return NO;
    }
    
    switch ([numType unsignedCharValue]) {
        case APNSFPTYPE_DEVICETOCKEN:
            if (![self setShort:APNSFLENGTH_DEVICETOCKEN toField:APNSFPH_CONTENTLENGTH byNetOrder:YES]) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_NOTIFICATIONID:
            if (![self setShort:APNSFLENGTH_NOTIFICATIONID toField:APNSFPH_CONTENTLENGTH  byNetOrder:YES]) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_EXPIRATION:
            if (![self setShort:APNSFLENGTH_EXPIRATION toField:APNSFPH_CONTENTLENGTH  byNetOrder:YES]) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_PRIORITY:
            if (![self setShort:APNSFLENGTH_PRIORITY toField:APNSFPH_CONTENTLENGTH  byNetOrder:YES]) {
                return NO;
            }
            break;
            
        case APNSFPTYPE_PAYLOAD:
            if ([self getHeaderField:APNSFPH_CONTENTLENGTH]==nil) {
                if ([self content]) {
                    if (![self setShort:[self contentLengthFilled] toField:APNSFPH_CONTENTLENGTH  byNetOrder:YES]) {
                        return NO;
                    }
                } else {
                    return NO;
                }
            }
            break;
            
        default:
            return NO;
            break;
    }
    return [super autoEndHeaders];
}

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey
{
    NSNumber *number;
    if ([headerKey isEqualToString:APNSFPH_TYPE]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if ([number unsignedIntegerValue]>APNSFPTYPE_MAXVALUE || [number unsignedIntegerValue]==0) {
                return NO;
            }
        } else {
            return NO;
        }
    }
    
    if ([headerKey isEqualToString:APNSFPH_CONTENTLENGTH]) {
        if ([NPPacket convertData:headerData ToNumber:&number]) {
            if (ntohs([number unsignedIntValue])==0) {
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
    
    if ([headerKey isEqualToString:APNSFPH_TYPE]) {
        return numberRet;
    }
    
    if ([headerKey isEqualToString:APNSFPH_CONTENTLENGTH]) {
        if (numberRet==nil) {
            return nil;
        }
        return [NSNumber numberWithLong:ntohs([numberRet unsignedShortValue])];
    }
    
    return [super getHeaderField:headerKey];
}


-(NSInteger)contentLengthToFill
{
    NSNumber *contentLen=[self getHeaderField:APNSFPH_CONTENTLENGTH];
    if (contentLen) {
        return [contentLen unsignedIntValue];
    }
    
    return NP_FILLRESULT_NEEDMORE;
}

-(BOOL)endPacket
{
    NSNumber *contentLen=[self getHeaderField:APNSFPH_CONTENTLENGTH];
    if (contentLen==nil) {
        return NO;
    }
    
    
    if ([self contentLengthFilled]!=[contentLen unsignedIntValue]) {
        return NO;
    }
    
    return [super endPacket];
}


@end
