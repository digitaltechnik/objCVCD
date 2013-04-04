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

-(id)initWithName:(NSString *)name Symbol:(NSString *)symbol {
    if(self = [super init]) {
        _values = [[NSMutableArray alloc] init];
        _symbol = symbol;
        _name = name;
    }
    return self;
}

-(void)addValue:(NSString *)value AtTime:(NSInteger)time {
    VCDValue *v = [[VCDValue alloc] initWithValue:value AtTime:time];
    
    
    // Damn slow, we should do smth else.
    [_values addObject:v];
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
    VCDValue *ov = [e nextObject];
    while (v = [e nextObject]) {
        [ov setNext: v];
        ov = v;
    }
    [[_values lastObject] setNext:nil];
}

-(VCDValue *)valueAtTime:(NSInteger) time {
    return [_values objectAtIndex:search(_values, time)];
}
@end
