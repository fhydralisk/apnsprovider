//
//  NPApnsClientEngine.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//
#import "NPMacro.h"
#import "NPApnsClientEngine.h"
#import <Security/Security.h>

@implementation NPApnsClientEngine
{
    BOOL _firstCanSend;
}

//@synthesize delegate;
@dynamic delegate;

-(BOOL)connect
{
    if (!_certData) {
        return NO;
    }
    
    
    /*if (![[NSFileManager defaultManager] fileExistsAtPath:_cert]) {
        return NO;
    }*/
    
    _firstCanSend=[super connect];
    return _firstCanSend;
}

-(BOOL)streamManagerShouldOpen:(NPStreamManager *)streamManager
{
    
    //get streams
    NSInputStream *inputStream=streamManager.inputStream;
    NSOutputStream *outputStream=streamManager.outputStream;
    assert(inputStream);
    assert(outputStream);
    
    //NSFileManager *fileMan=[NSFileManager defaultManager];
    //BOOL isDir=NO;
    //assert([fileMan fileExistsAtPath:_cert isDirectory:&isDir]);
    //assert(!isDir);
    
    // set Stream secuerty mode
    
    [streamManager setStreamProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
    
    // open cert file.
    //NSData *certData=[NSData dataWithContentsOfFile:_cert];
    if (_certData==nil) {
        // file load failed.
        NPLog(@"cert file load failed");
        return NO;
    }
    
    //create a certificate
    SecCertificateRef certificate=SecCertificateCreateWithData(NULL, (__bridge CFDataRef)_certData);
    if (certificate==NULL) {
        // certificate create failed.
        NPLog(@"certificate create failed");
        return NO;
    }
    
    //create a identity
    SecIdentityRef identity=NULL;
    SecIdentityCreateWithCertificate(NULL, certificate, &identity);
    CFRelease(certificate);
    
    if (identity==NULL) {
        NPLog(@"identity create failed");
        return NO;
    }
    
    //bind the identity to both of the streams
    NSArray *sslCertificates=[NSArray arrayWithObjects:CFBridgingRelease(identity), nil];
    NSDictionary *sslSettings=[NSDictionary dictionaryWithObjectsAndKeys:sslCertificates, kCFStreamSSLCertificates, nil];
    BOOL retV=YES;
    
    retV =
        CFReadStreamSetProperty((__bridge CFReadStreamRef)inputStream,
                                kCFStreamPropertySSLSettings,
                                (__bridge CFTypeRef)(sslSettings));
    
    retV= retV &&
        CFWriteStreamSetProperty((__bridge CFWriteStreamRef)outputStream,
                                 kCFStreamPropertySSLSettings,
                                 (__bridge CFTypeRef)(sslSettings));
    
    return retV;
    
}

-(void)streamManagerCanSendData:(NPStreamManager *)streamManager
{
    if (_firstCanSend) {
        _firstCanSend=NO;
        if ([self.delegate respondsToSelector:@selector(clientEngineSSLHandshakeSucceed:)] ) {
            [self.delegate performSelector:@selector(clientEngineSSLHandshakeSucceed:) withObject:self];
        }
    }
    [super streamManagerCanSendData:streamManager];
}


@end
