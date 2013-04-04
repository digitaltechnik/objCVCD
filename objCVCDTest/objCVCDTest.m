//
//  objCVCDTest.m
//  objCVCDTest
//
//  Created by tox on 04.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "objCVCDTest.h"

@implementation objCVCDTest

#define ASYNC dispatch_semaphore_t __sem = dispatch_semaphore_create(0)
#define ASYNC_WAIT while (dispatch_semaphore_wait(__sem, DISPATCH_TIME_NOW)) \
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode \
    beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
#define ASYNC_DONE dispatch_semaphore_signal(__sem)

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSamples
{
    NSDictionary *dict = [VCD loadAvailableSamples];
    for (id obj in [dict allKeys]) {
        if(![obj isKindOfClass:[NSString class]]) {
            STFail(@"key should be NSString. But it's %@", [[obj class] description]);
        }
    }
    
    for (id obj in [dict allValues]) {
        if(![obj isKindOfClass:[NSURL class]]) {
            STFail(@"value should be NSURL. But it's %@", [[obj class] description]);
        }
    }
}

- (void) testLoadURL
{
    ASYNC;
    
    [VCD loadWithURL:[NSURL URLWithString:@"http://eboland.de/simple.vcd"] callback:^(VCD *vcd) {
        _vcd = vcd;
        ASYNC_DONE;
    }];
    
    ASYNC_WAIT;
    
    if(_vcd == nil)
        STFail(@"Error loading VCD file!");
}

- (void) testLoadFileSimple
{
    ASYNC;
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource:@"simple" ofType:@"vcd"];
    [VCD loadWithPath:filePath callback:^(VCD *vcd) {
        _vcd = vcd;
        ASYNC_DONE;
    }];
    ASYNC_WAIT;
    
    if(_vcd == nil)
        STFail(@"Error loading VCD file!");
}

- (void) testLoadFileVerySimple
{
    ASYNC;
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource:@"very_simple" ofType:@"vcd"];
    [VCD loadWithPath:filePath callback:^(VCD *vcd) {
        _vcd = vcd;
        ASYNC_DONE;
    }];
    ASYNC_WAIT;
    
    if(_vcd == nil)
        STFail(@"Error loading VCD file!");
}


-(void) testParsedSignalSymbols
{
    [self testLoadFileVerySimple];
    
    for (VCDSignal *signal in [[_vcd signals] allValues]) {
        STAssertEquals([[signal symbol] length], (NSUInteger)1, @"Signal Symbols should be length 1.");
    }
}

-(void) testSignalAddValues
{
    VCDSignal *signal = [[VCDSignal alloc] initWithName:@"Test" Symbol:@"T"];
    [signal addValue:@"v2" AtTime:2];
    [signal addValue:@"v0" AtTime:0];
    [signal addValue:@"v3" AtTime:3];
    [signal addValue:@"v4" AtTime:4];
    [signal addValue:@"v1" AtTime:1];
    
    VCDValue *v = [signal valueAtTime:0];
    int i;
    for(i = 0; v != nil; i++, v = [v next]) {
        NSString *expected = [NSString stringWithFormat:@"v%d", i];
        STAssertEqualObjects([v value], expected, @"Wrong value!");
    }
    STAssertEquals(i, 5, @"Didn't iterator all objects!");
}

-(void) testSignalSearchExact
{
    VCDSignal *signal = [[VCDSignal alloc] initWithName:@"Test" Symbol:@"T"];
    [signal addValue:@"v0" AtTime:0];
    [signal addValue:@"v75" AtTime:75];
    [signal addValue:@"v100" AtTime:100];
    
    STAssertEquals([[signal valueAtTime:0] time], 0, @"");
    STAssertEquals([[signal valueAtTime:75] time], 75, @"");
    STAssertEquals([[signal valueAtTime:100] time], 100, @"");
}

-(void) testSignalSearchBetween
{
    VCDSignal *signal = [[VCDSignal alloc] initWithName:@"Test" Symbol:@"T"];
    [signal addValue:@"v0" AtTime:0];
    [signal addValue:@"v75" AtTime:75];
    [signal addValue:@"v100" AtTime:100];
    
    STAssertEquals([[signal valueAtTime:5] time], 0, @"");
    STAssertEquals([[signal valueAtTime:80] time], 75, @"");
    STAssertEquals([[signal valueAtTime:150] time], 100, @"");
}
@end





















