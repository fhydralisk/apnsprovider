//
//  NPPayloadTemplates.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPPayloadTemplates.h"

@implementation NPPayloadTemplates

-(void)buildFromPlist:(NSString *)plistName
{
    NSDictionary *dictTemplates=
    [NSDictionary dictionaryWithContentsOfFile:
     [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
    
    
    // arrayTemplates - root array of templates in plist file
    NSArray *arrayTemplates=[dictTemplates objectForKey:TPKEY_ROOT];
    assert([arrayTemplates isKindOfClass:[NSArray class]]);
    
    // templateNames - array of template names to be filled in property of _templateNames
    NSString *templateNames[[arrayTemplates count]];
    
    // templateNames - array of payload contents to be filled in property of _payloadContents
    NSString *payloadContents[[arrayTemplates count]];
    
    
    for (int i=0; i<[arrayTemplates count]; i++) {
        // dictTemplate - the dictionary with two keys (TPKEY_TEMPLATENAME, TPKEY_PAYLOADCONTENT) of each template in plist file.
        NSDictionary *dictTemplate=[arrayTemplates objectAtIndex:i];
        assert([dictTemplate isKindOfClass:[NSDictionary class]]);
        
        NSString *templateName=[dictTemplate objectForKey:TPKEY_TEMPLATENAME];
        assert([templateName isKindOfClass:[NSString class]]);
        
        NSString *payloadContent=[dictTemplate objectForKey:TPKEY_PAYLOADCONTENT];
        assert([payloadContent isKindOfClass:[NSString class]]);
        
        templateNames[i]=templateName;
        payloadContents[i]=payloadContent;
    }
    
    _templateNames=[NSArray arrayWithObjects:templateNames count:[arrayTemplates count]];
    _payloadContents=[NSArray arrayWithObjects:payloadContents count:[arrayTemplates count]];
    
}

-(NSString *)getPayloadContentAtIndex:(NSUInteger)index
{
    if (index>=[_payloadContents count]) {
        return nil;
    }
    
    return [_payloadContents objectAtIndex:index];
    //return nil;
}

-(NSString *)getTemplateNameAtIndex:(NSUInteger)index
{
    if (index>=[_templateNames count]) {
        return nil;
    }
    
    return [_templateNames objectAtIndex:index];
 
}

-(NSUInteger)count
{
    return [_templateNames count];
}
@end
