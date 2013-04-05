//
//  VCD.m
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "VCD.h"
#import "VCDParser.h"

#define EXAMPLE_LIST_URL @"http://eboland.de:8080/vcd.json"

@implementation VCD

@synthesize timeScale = _timeScale;
@synthesize timeScaleUnit = _timeScaleUnit;
@synthesize date = _date;
@synthesize signals = _signalsByName;
@synthesize version = _version;
@synthesize scope = _scope;


+(void)loadWithPath:(NSString *)path callback:(void(^)(VCD *))cb {
    NSURL *_url = [[NSURL alloc] initFileURLWithPath:path isDirectory:false];
    
    if(_url == nil)
        cb(nil);
    else
        [VCD loadWithURL:_url callback:cb];
}

+(void)loadWithURL:(NSURL *)url callback:(void(^)(VCD *vcd))cb {
    VCD *vcd = [[VCD alloc] init];

    
    VCDParser *parser = [[VCDParser alloc] initWithVCD:vcd callback:cb];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:parser];
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
}

+(NSDictionary *)loadAvailableSamples {
    NSError *e = nil;
    NSURLRequest *req = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:EXAMPLE_LIST_URL]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&e];
    id json;
    
    if(e == nil)
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
    
    if(e != nil) {
        NSLog(@"[VCD loadAvailableSamples]: JSON parse error: %@", [e localizedDescription]);
    }
    else if ([json isKindOfClass:[NSDictionary class]] == NO) {
        NSLog(@"[VCD loadAvailableSamples]: JSON root object should be an object");
    }
    else {
        NSDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"samples"]];
        for (NSString *key in [dict allKeys]) {
            NSURL *url = [NSURL URLWithString:[dict objectForKey:key]];
            [dict setValue:url forKey:key];
        }
        return dict;
    }
    return nil;
}

-(id)init {
    if(self = [super init]) {
        _signalsBySymbol = [[NSMutableDictionary alloc] init];
        _signalsByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(VCDSignal *)signalWithName:(NSString *)name {
    NSString *symbol = [_signalsBySymbol objectForKey:name];
    if(symbol == nil)
        return nil;
    
    return [_signalsByName objectForKey:symbol];
}

-(void)defineSignal:(NSString *)name Symbol:(NSString *)symbol {
    VCDSignal *signal = [[VCDSignal alloc] initWithName:name Symbol:symbol];
    [_signalsByName setObject:signal forKey:name];
    [_signalsBySymbol setObject:signal forKey:symbol];
}

-(void)defineSignalChange:(NSString *)symbol Time:(int)time Value:(NSString *)value {
    VCDSignal *signal = [_signalsBySymbol objectForKey:symbol];
    [signal addValue:value AtTime:time];
}
@end
