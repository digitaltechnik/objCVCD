//
//  Signal.h
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCDValue.h"

@interface VCDSignal : NSObject {
    NSString *_name;
    NSString *_symbol;
    NSMutableArray *_values;
}
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *symbol;
-(id)initWithName:(NSString *)name Symbol:(NSString *)symbol;
-(VCDValue *)valueAtTime:(NSInteger) time;


-(void)addValue:(NSString *)value AtTime:(NSInteger)time;
@end
