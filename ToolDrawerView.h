//
//  ToolDrawerView.m
//
//  Created by Ayal Spitz on 7/17/11.
//  Copyright 2011 Ayal Spitz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kTopCorner = 1,
    kBottomCorner = -1
} ToolDrawerVerticalCorner;

typedef enum{
    kLeftCorner = 1,
    kRightCorner = -1
} ToolDrawerHorizontalCorner;

typedef enum{
    kHorizontally,
    kVertically
} ToolDrawerDirection;

@interface ToolDrawerView : UIView {
    NSTimer *toolbarFadeTimer;

    CGPoint openPosition;
    CGPoint closePosition;

    CGAffineTransform positionTransform;
    
    NSTimer *tabButtonBlinkTimer;

    UIButton *tabButton;
    UIImage *tabButtonImage;
    UIImage *tabButtonBlinkImage;
    
    BOOL open;
	
	NSTimeInterval durationToFade;
	NSTimeInterval perItemAnimationDuration;
}

@property (assign) ToolDrawerHorizontalCorner horizontalCorner;
@property (assign) ToolDrawerVerticalCorner verticalCorner;
@property (assign) ToolDrawerDirection direction;
@property (nonatomic, retain) UIButton *tabButton;

@property (assign) NSTimeInterval durationToFade;
@property (assign) NSTimeInterval perItemAnimationDuration;


- (id)initInVerticalCorner:(ToolDrawerVerticalCorner)vCorner andHorizontalCorner:(ToolDrawerHorizontalCorner)hCorner moving:(ToolDrawerDirection)aDirection;

- (void)blinkTabButton;

- (UIButton *)appendItem:(NSString *)imageName;    
- (UIButton *)appendImage:(UIImage *)img;
- (void)appendButton:(UIButton *)button;

- (bool)isOpen;
- (void)open;
- (void)close;

@end
