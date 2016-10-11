//
//  NPTokenPacket.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPTokenPacket.h"
static NSArray *tokenHeaderDescription;
static NSArray *tokenHeaderLength;

@implementation NPTokenPacket

+(void)initialize
{
    tokenHeaderDescription=@[TKPH_TOKEN];
    tokenHeaderLength=@[@TKPH_LENGTH_TOKEN];
}


+(NSArray *)headerFieldsDescription
{
    return tokenHeaderDescription;
}

+(NSArray *)headerFieldsLength
{
    return tokenHeaderLength;
}

-(BOOL)endHeaders
{
    return [super endHeaders];
}

-(BOOL)autoEndHeaders
{
    return NO;
}

-(NSData *)canSetData:(NSData *)headerData toField:(NSString *)headerKey
{
    return [super canSetData:headerData toField:headerKey];
}

-(id)getHeaderField:(NSString *)headerKey
{
    //NSNumber *ret;
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
