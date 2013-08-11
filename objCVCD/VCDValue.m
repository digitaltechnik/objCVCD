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
        _value[sizeof _value - 1] = '\0';
        [self setCValue:value];
    }
    return self;
}

- (char *)cValue {
    return _value;
}

- (void)setCValue:(const char *)value {
    strncpy(_value, value, sizeof _value - 1);
}

- (NSString *)value {
    return [[NSString alloc] initWithCString:_value encoding:NSUTF8StringEncoding];
}

@end
