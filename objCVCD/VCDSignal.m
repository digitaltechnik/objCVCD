//
//  Signal.m
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "VCDSignal.h"

static NSInteger search(NSArray *array, NSInteger time) {
    NSInteger start = 0,
        end = [array count],
        split, splitTime;
    if(end == 0)
        return 0;
    do {
        split = (end - start) / 2 + start;
        splitTime = [[array objectAtIndex:split] time];
        if(splitTime > time)
            end = split;
        else if(splitTime < time)
            start = split;
        else
            return split;
    } while(end - start > 1);
    if(end < [array count] && [[array objectAtIndex:end] time] == time)
        return end;
    else
        return start;
}

@implementation VCDSignal
@synthesize name = _name;
@synthesize symbol = _symbol;
@synthesize type = _type;
@synthesize bits = _bits;

-(id)initWithType:(NSString *)type Bits:(int)bits Name:(NSString *)name Symbol:(NSString *)symbol {
    if(self = [super init]) {
        _values = [[NSMutableArray alloc] init];
        _symbol = symbol;
        _name = name;
        _bits = bits;
        if([@"wire" isEqualToString:type])
            _type = VCD_TYPE_WIRE;
        else
            _type = VCD_TYPE_UNKOWN;
        _sorted = true;
        _lastTime = -1;
    }
    return self;
}

-(void)addValue:(char *)value AtTime:(NSInteger)time {
    VCDValue *v = [[VCDValue alloc] initWithValue:value AtTime:time];
    
    if(_lastTime < time || _sorted == false) {
        _sorted = false;
    }
    else {
        VCDValue *ov = [_values lastObject];
        [ov setNext:v];
    }
    [_values addObject:v];
    _lastTime = time;
}

-(VCDValue *)valueAtTime:(NSInteger) time {
    if([_values count] == 0)
        return nil;
    
    // If data isn't sorted, do that now
    if(_sorted == false) {
        [_values sortUsingComparator:^NSComparisonResult(VCDValue *v1, VCDValue *v2) {
            if([v1 time] < [v2 time])
                return NSOrderedAscending;
            else if([v1 time] > [v2 time])
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        
        // Rebuild list

        NSEnumerator *e = [_values objectEnumerator];
        VCDValue *v, *ov = [e nextObject];
        while (v = [e nextObject]) {
            [ov setNext: v];
            ov = v;
        }
        [[_values lastObject] setNext:nil];
        
        _sorted = true;
    }
    return [_values objectAtIndex:search(_values, time)];
}
@end
