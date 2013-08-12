//
//  VCDValue.m
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "VCDValue.h"

@implementation VCDValue
@synthesize time = _time;
@synthesize next = _next;

-(id)initWithValue:(char *)value AtTime:(NSInteger)time {
    if(self = [super init]) {
        _time = time;
        _next = nil;
        _cValue[sizeof _cValue - 1] = '\0';
        [self setCValue:value];
    }
    return self;
}

- (char *)cValue {
    return _cValue;
}

- (void)setCValue:(const char *)value {
    strncpy(_cValue, value, sizeof _cValue - 1);
}

- (NSString *)value {
    return [[NSString alloc] initWithCString:_cValue encoding:NSUTF8StringEncoding];
}

@end
