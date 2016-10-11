//
//  NPMacro.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/4/28.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//


#ifdef DEBUG
#define NPLog(format,...) NSLog(format, ##__VA_ARGS__)
#else
#define NPLog(format,...)
#endif
