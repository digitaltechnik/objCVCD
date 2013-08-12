//
//  Signal.h
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCDValue.h"

enum SignalType {
    VCD_TYPE_UNKOWN,
    VCD_TYPE_WIRE
};

@interface VCDSignal : NSObject {
    NSString *_name;
    NSString *_symbol;
    NSInteger _bits;
    enum SignalType _type;
    NSMutableArray *_values;
    BOOL _sorted;
    int _lastTime;
}
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *symbol;
@property (readonly, nonatomic) enum SignalType type;
@property (readonly, nonatomic) NSInteger bits;

-(id)initWithType:(NSString *)type Bits:(int)bits Name:(NSString *)name Symbol:(NSString *)symbol;
-(VCDValue *)valueAtTime:(NSInteger) time;

-(void)addValue:(char *)value AtTime:(NSInteger)time;
@end
