//
//  CDColorPicker.m
//
//  Created by Lacy Rhoades on 1/27/13.
//  Copyright (c) 2013 colordeaf ltd. All rights reserved.
//

#import "CDColorPicker.h"

@implementation CDColorPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSelectedColor:[UIColor blackColor]];
        
        _swatchesView = [self swatchesView];
        [_swatchesView setHidden:YES];
        [self addSubview:_swatchesView];
        
        _selectedColorView = [self selectedColorView];
        [_selectedColorView setHidden:YES];
        [self addSubview:_selectedColorView];
        
        [self addTarget:self action:@selector(collapsedViewWasTapped) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(collapsedViewWasReleasedWithSender:andEvent:) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside)];
    }
    return self;
}

- (CDColorPickerSwatchesView *)swatchesView {
    if (!_swatchesView) {
        CGRect buttonBounds = [self frame];
        CGRect maxBounds = [[UIScreen mainScreen] applicationFrame];
        
        NSInteger swatchesWidth = 200;
        NSInteger swatchesHeight = 200;
        
        NSInteger xPadding = 5;
        NSInteger yPadding = 5;
        
        NSInteger swatchesX = 0 - (swatchesWidth - buttonBounds.size.width) / 2.0;
        NSInteger swatchesY = 0 - (swatchesHeight - buttonBounds.size.height) / 2.0;;
        
        if (buttonBounds.origin.x + swatchesX + swatchesWidth + xPadding > maxBounds.size.width) {
            swatchesX = maxBounds.size.width - xPadding - swatchesWidth - buttonBounds.origin.x;
        }
        
        if (buttonBounds.origin.x + swatchesX < 0) {
            swatchesX = 0 - buttonBounds.origin.x + xPadding;
        }
        
        NSLog(@"%f, %d, %d, %d", buttonBounds.origin.y, swatchesY, swatchesHeight, yPadding);
        
        if (buttonBounds.origin.y + swatchesY + swatchesHeight + yPadding > maxBounds.size.height) {
            NSLog(@"%f, %d, %d, %f", maxBounds.size.height, yPadding, swatchesHeight, buttonBounds.origin.y);
            swatchesY = maxBounds.size.height - yPadding - swatchesHeight - buttonBounds.origin.y;
        }
        
        if (buttonBounds.origin.y + swatchesY < 0) {
            swatchesY = 0 - buttonBounds.origin.y + yPadding;
        }

        _swatchesView = [[CDColorPickerSwatchesView alloc]initWithFrame:CGRectMake(swatchesX, swatchesY, swatchesWidth, swatchesHeight)];
    }

    return _swatchesView;
}

- (UIView *)selectedColorView {
    if (!_selectedColorView) {
        _selectedColorView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 100, 100)];
        [[_selectedColorView layer] setMasksToBounds:NO];
        [[_selectedColorView layer] setShadowOffset:CGSizeMake(8, 8)];
        [[_selectedColorView layer] setShadowOpacity:0.5];
    }
    
    return _selectedColorView;
}

- (void)collapsedViewWasTapped {
    if (_previouslySelectedColor) {
        [_previouslySelectedColor release];
    }

    _previouslySelectedColor = [[self selectedColor] retain];
    
    [_swatchesView setHidden:NO];
}

- (void)collapsedViewWasReleasedWithSender:(id)sender andEvent:(UIEvent *)event {
    CGPoint lastTouch = [[[event touchesForView:self] anyObject] locationInView:_swatchesView];
    
    if (![_swatchesView hitTest:lastTouch withEvent:event]) {
        [self setSelectedColor:_previouslySelectedColor];
    }

    [self setBackgroundColor:[self selectedColor]];
    
    [_selectedColorView setHidden:YES];
    
    [_swatchesView setHidden:YES];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint lastTouchRelativeToSwatches = [[[event touchesForView:self] anyObject] locationInView:_swatchesView];
    
    UIColor *selectedColor = [_swatchesView colorForPoint:lastTouchRelativeToSwatches];
    
    if ([_swatchesView hitTest:lastTouchRelativeToSwatches withEvent:event]) {
        [self setSelectedColor:selectedColor];
    } else {
        selectedColor = [UIColor clearColor];
    }

    [_selectedColorView setBackgroundColor:selectedColor];
    
    [_selectedColorView setHidden:NO];

    CGRect updatedFrame = [_selectedColorView frame];
    
    CGPoint lastTouchRelativeToSelector = [[[event touchesForView:self] anyObject] locationInView:self];

    updatedFrame.origin = CGPointMake(
                                      lastTouchRelativeToSelector.x - _selectedColorView.frame.size.width / 2.0,
                                      lastTouchRelativeToSelector.y - _selectedColorView.frame.size.height / 2.0
                                      );
    
    [_selectedColorView setFrame:updatedFrame];
    
    return YES;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (_selectedColor) {
        [_selectedColor release];
    }

    _selectedColor = [selectedColor retain];
    [self setBackgroundColor:selectedColor];
}

- (void)dealloc {
    [_selectedColor release];
    [_previouslySelectedColor release];
    [_selectedColorView release];
    [_swatchesView release];
    [super dealloc];
}

@end

@implementation CDColorPickerSwatchesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[self layer] setMasksToBounds:NO];
        [[self layer] setShadowOffset:CGSizeMake(8, 8)];
        [[self layer] setShadowOpacity:0.5];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    int swatchWidth = 20, swatchHeight = 20;
    
    CGFloat components[4];
    
    CGRect fillFrame = [self frame];
    
    for (int x = 0; x <= fillFrame.size.width; x++) {
        for (int y = 0; y <= fillFrame.size.height; y++) {
            if (x % swatchHeight == 0 && y % swatchHeight == 0) {
                components[0] = (arc4random() % 100) / 100.0;
                components[1] = (arc4random() % 100) / 100.0;
                components[2] = (arc4random() % 100) / 100.0;
                components[3] = 1;
                CGContextSetFillColorWithColor(c, CGColorCreate(CGColorSpaceCreateDeviceRGB(), components));
                CGContextFillRect(c, CGRectMake(x, y, swatchWidth, swatchHeight));
            }
        }
    }
}

- (UIColor *) colorForPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end