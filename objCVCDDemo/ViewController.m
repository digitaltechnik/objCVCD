//
//  ViewController.m
//  objCVCDDemo
//
//  Created by tox on 27.06.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import "ViewController.h"
#import "VCD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadExamples:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)load:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] init];
    UIButton* button = (UIButton*)sender;
    
    if(_samples == nil) {
        _output.text = @"load examples first";
        return;
    }
    
    [VCD loadWithURL:[_samples objectForKey:[[button titleLabel] text]] callback:^(VCD *vcd) {
        for (VCDSignal *sig in [[vcd signals] allValues]) {
            [str appendString:[sig name]];
            [str appendString:@": "];
            for(VCDValue *v = [sig valueAtTime:0]; v != nil; v = [v next]) {
                [str appendString:[v value]];
                [str appendString:@", "];
            }
            [str appendString:@"\n"];
        }
        _output.text = str;
    }];
}

- (IBAction)loadExamples:(id)sender {

    NSMutableString *str = [[NSMutableString alloc] init];
    
    NSDictionary *samples = [VCD loadAvailableSamples];
    
    for (NSString *title in [samples allKeys]) {
        NSURL *url = [samples objectForKey:title];
        [str appendString:title];
        [str appendString:@" = "];
        [str appendString:[url absoluteString]];
        [str appendString:@"\n"];
    }
    
    _output.text = str;
    
    _samples = samples;
}
@end
