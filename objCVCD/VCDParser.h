//
//  VCDParser.h
//  VCDLibrary
//
//  Created by tox on 03.04.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCD.h"

// You don't need to call this parser directly. All you need is in VCD.h.

typedef void (^VCDCompleteCallback)(VCD *vcd);

@interface VCDParser : NSObject {
@private
    NSMutableString *_dataChunk;
    VCD *_vcd;
    SEL _parseChunk;
    
    VCDCompleteCallback _callback;
    NSString *_currentCommand;
    int _currentTime;
}

-(id)initWithVCD:(VCD *)vcd callback:(void(^)(VCD *))cb;
@end
