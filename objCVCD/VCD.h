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
}
@property (readonly) NSDictionary *signals;
@property (readonly) NSInteger count;

+(void)loadWithPath:(NSString *)path callback:(void(^)(VCD *))cb;
+(void)loadWithURL:(NSURL *)url callback:(void (^)(VCD *))cb;
+(NSDictionary *)loadAvailableSamples;

-(id)init;
-(VCDSignal *)signalWithName:(NSString *)name;

-(void)defineSignal:(NSString *)name Symbol:(NSString *)symbol;
-(void)defineSignalChange:(NSString *)symbol Time:(int)time Value:(NSString *)value;
@end
