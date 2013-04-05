//
//  VCDParser.m
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "VCDParser.h"
#include <ctype.h>

@implementation VCDParser

-(NSNumber *)parseHeader
{
    const char *chunk = [_dataChunk UTF8String];
    int len = [_dataChunk length];
    int i = 0;
    while(isspace(chunk[i])) i++;
    if(i == len)
        return [NSNumber numberWithInt:i];
    else if(chunk[i] == '$') {
        i++;
        _parseChunk = @selector(parseCommandBegin);
    }
    else if(chunk[i] == '#') {
        i++;
        _parseChunk = @selector(parseTime);
    }
    else
        _parseChunk = @selector(parseValue);
    return [NSNumber numberWithInt:i];
}

-(NSNumber *)parseCommandBegin
{
    const char *chunk = [_dataChunk UTF8String];
    int i = 0;
    while(isalnum(chunk[i])) i++;
    
    if(isspace(chunk[i])) {
        _currentCommand = [[NSString alloc] initWithBytes:chunk length:i encoding:NSUTF8StringEncoding];
        if([@"end" isEqualToString:_currentCommand]
           || [@"dumpvars" isEqualToString:_currentCommand])
            _parseChunk = @selector(parseHeader);
        else
            _parseChunk = @selector(parseCommand);
    }
    return [NSNumber numberWithInt:i];
}

-(NSArray *)strTokens:(NSString *)str maxFields:(int)max {
    NSRange range = NSMakeRange(0, 0);
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:max];
    int field = 0;
    for(int i = 0; i < [str length] && field < max - 1; i++, range.length++) {
        if(isspace([str characterAtIndex:i])) {
            [result addObject:[str substringWithRange:range]];
            field++;
            while(isspace([str characterAtIndex:i])) i++;
            range = NSMakeRange(i, 0);
        }
    }
    
    if(range.location < [str length])
        [result addObject:[str substringFromIndex:range.location]];
    return result;
}

-(BOOL)parseVar:(NSString *)varDef
{
    NSArray *arr = [self strTokens:varDef maxFields:4];
    [_vcd defineSignal:[arr objectAtIndex:3] Symbol:[arr objectAtIndex:2]];
    return [arr count] == 4;
}

-(BOOL)parseTimeScale:(NSString *)timeScaleDef
{
    NSRange unitRange = [timeScaleDef rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    [_vcd setTimeScale:[timeScaleDef intValue]];
    [_vcd setTimeScaleUnit:[timeScaleDef substringFromIndex:unitRange.location]];
    return YES;
}

-(BOOL)parseDate:(NSString *)dateDef
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone localTimeZone]];
    //                      Wed Oct 27 17:30:33 2010
    [format setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
    [_vcd setDate:[format dateFromString:dateDef]];
    return YES;
}

-(NSNumber *)parseCommand
{
    NSRange range = [_dataChunk rangeOfString:@"$end"];
    if(range.location == NSNotFound)
        return [NSNumber numberWithInt:0];
    
    NSString *args = [[_dataChunk substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //NSLog(@"cmd: %@", _currentCommand);
    BOOL success = YES;
    
    if([@"var" isEqualToString:_currentCommand]) {
        success = [self parseVar:args];
    }
    else if([@"timescale" isEqualToString:_currentCommand]) {
        success = [self parseTimeScale:args];
    }
    else if([@"date" isEqualToString:_currentCommand]) {
        success = [self parseDate:args];
    }
    else if([@"version" isEqualToString:_currentCommand]) {
        [_vcd setVersion:args];
    }
    else if([@"scope" isEqualToString:_currentCommand]) {
        [_vcd setScope:args];
    }
    else if(![@[@"upscope", @"enddefinitions"] containsObject:_currentCommand]) {
        NSLog(@"Unknown Command %@; args: %@", _currentCommand, args);
    }
    
    _parseChunk = @selector(parseHeader);
    return [NSNumber numberWithInt:success ? range.location + range.length : -1];

}

-(NSNumber *)parseTime
{
    const char *chunk = [_dataChunk UTF8String];
    
    int i = 0;
    while(isnumber(chunk[i])) i++;
    if(!isspace(chunk[i]))
        return [NSNumber numberWithInt:0];
    
    _currentTime = atoi(chunk);
    
    _parseChunk = @selector(parseHeader);
    return [NSNumber numberWithInt:i];
}

-(NSNumber *)parseValue
{
    if([_dataChunk length] < 2)
        return [NSNumber numberWithInt:0];
    
    NSString *value = [_dataChunk substringToIndex:1];
    NSString *symbol = [_dataChunk substringWithRange:NSMakeRange(1, 1)];
    [_vcd defineSignalChange:symbol Time:_currentTime Value:value];
    _parseChunk = @selector(parseHeader);
    return [NSNumber numberWithInt:2];
}

-(id)initWithVCD:(VCD *)vcd callback:(void(^)(VCD *))cb
{
    if(self = [super init]) {
        _dataChunk = [[NSMutableString alloc] init];
        _vcd = vcd;
        _parseChunk = @selector(parseHeader);
        _callback = cb;
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    int len, offset = 0, chunkLen;
    const char *chunk;
    
    [_dataChunk appendString:[[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding]];
    offset = 0;
    chunk = [_dataChunk UTF8String];
    chunkLen = [_dataChunk length];
    
    do {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if((len = [[self performSelector:_parseChunk] intValue]) < 0) {
#pragma clang diagnostic pop
            NSLog(@"Parser Error!");
            [connection cancel];
            return;
        }
        [_dataChunk deleteCharactersInRange:NSMakeRange(0, len)];
    } while(len > 0);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _callback(_vcd);
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    _callback(nil);
}

@end
