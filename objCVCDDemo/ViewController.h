//
//  ViewController.h
//  objCVCDDemo
//
//  Created by tox on 27.06.13.
//  Copyright (c) 2013 Uni Kassel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)load    :(id)sender;
- (IBAction)loadExamples:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *output;
@property (strong, nonatomic) NSDictionary *samples;
@end
