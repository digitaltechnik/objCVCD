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
@synthesize value = _value;
@synthesize next = _next;

-(id)initWithValue:(NSString *)value AtTime:(NSInteger)time {
    if(self = [super init]) {
        _time = time;
        _value = value;
        _next = nil;
    }
    return self;
}
@end
