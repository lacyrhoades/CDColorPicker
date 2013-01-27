//
//  CDViewController.m
//  CDColorPickerDemo
//
//  Created by Lacy Rhoades on 1/25/13.
//  Copyright (c) 2013 colordeaf ltd. All rights reserved.
//

#import "CDViewController.h"

@interface CDViewController ()

@end

@implementation CDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _coloredThinger = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)] autorelease];
    
    [_coloredThinger setBackgroundColor:[UIColor blackColor]];
    
    [[self view] addSubview:_coloredThinger];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 350, 320, 40)] autorelease];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setBackgroundColor:[UIColor clearColor]];
    
    [label setText:@"What color do you want to be?"];
    
    [[self view] addSubview:label];
    
    CDColorPicker *picker = [[[CDColorPicker alloc]initWithFrame:CGRectMake(140, 400, 40, 40)] autorelease];
    
    [picker addTarget:self action:@selector(colorPickerValueDidChangeWithSender:andEvent:) forControlEvents:UIControlEventValueChanged];
    
    [[self view] addSubview:picker];
}

- (void)colorPickerValueDidChangeWithSender:(id)sender andEvent:(UIEvent *)event {
    UIColor *selectedColor = [(CDColorPicker *)sender selectedColor];
    
    [_coloredThinger setBackgroundColor:selectedColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
