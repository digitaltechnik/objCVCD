//
//  VCDValue.h
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCDValue : NSObject {
@private
    NSInteger _time;
    char _value[5];
    VCDValue *_next;
}
@property (readonly, nonatomic) NSInteger time;
@property (readonly, nonatomic) char *cValue;
@property (readonly, nonatomic) NSString *value;
@property () VCDValue *next;

-(id)initWithValue:(char *)value AtTime:(NSInteger)time;
@end
