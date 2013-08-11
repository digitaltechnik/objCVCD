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
        _value[0] = '\0';
        _next = nil;
    }
    return self;
}

- (char *)value {
    return _value;
}

- (void)setValue:(const char *)value {
    strncpy(_value, value, sizeof _value - 1);
}

@end
