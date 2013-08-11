//
//  VCD.h
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCDSignal.h"

@interface VCD : NSObject {
@public
    NSMutableDictionary *_signalsBySymbol;
    NSMutableDictionary *_signalsByName;
    
    NSInteger _timeScale;
    NSString *_timeScaleUnit;
    NSDate *_date;
    NSString *_version;
    NSString *_scope;
}
@property (readonly) NSDictionary *signals;
@property (nonatomic) NSInteger timeScale;
@property (nonatomic) NSString *timeScaleUnit;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *version;
@property (nonatomic) NSString *scope;

+(void)loadWithPath:(NSString *)path callback:(void(^)(VCD *))cb;
+(void)loadWithURL:(NSURL *)url callback:(void (^)(VCD *))cb;
+(NSDictionary *)loadAvailableSamples;

-(id)init;
-(VCDSignal *)signalWithName:(NSString *)name;


-(void)defineSignalWithType:(NSString *)type Bits:(int)bits Name:(NSString *)name Symbol:(NSString *)symbol;
-(void)defineSignalChange:(NSString *)symbol Time:(int)time Value:(char *)value;
@end
