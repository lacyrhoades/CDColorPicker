//
//  CDColorPicker.h
//  CDColorPickerDemo
//
//  Created by Lacy Rhoades on 1/27/13.
//  Copyright (c) 2013 colordeaf ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CDColorPickerSwatchesView : UIView {
    float colors[1000][1000][4];
}
- (UIColor *)colorForPoint:(CGPoint)point;
@end

@interface CDColorPicker : UIControl {
    CDColorPickerSwatchesView *_swatchesView;
    UIView *_selectedColorView;
    UIColor *_previouslySelectedColor;
}
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, assign) id *delegate;
@end
