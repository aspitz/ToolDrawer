//
//  ToolDrawerView.m
//
//  Created by Ayal Spitz on 7/17/11.
//  Copyright 2011 Ayal Spitz. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
    NSTimer *toolDrawerFadeTimer;

    CGPoint openPosition;
    CGPoint closePosition;

    CGAffineTransform positionTransform;
    
    UIButton *handleButton;
    UIImage *handleButtonImage;
    UIImage *handleButtonBlinkImage;
    NSTimer *handleButtonBlinkTimer;
    
    BOOL open;
}

@property (assign) ToolDrawerHorizontalCorner horizontalCorner;
@property (assign) ToolDrawerVerticalCorner verticalCorner;
@property (assign) ToolDrawerDirection direction;
@property (nonatomic, retain) UIButton *handleButton;

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
