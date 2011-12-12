
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

#import "ToolDrawerView.h"

// Declaring private methods, not really ment for public consumption
@interface ToolDrawerView(Private)

- (void)createTabButton;
- (UIImage *)createTabButtonImageWithFillColor:(UIColor *)fillColor;
- (void)flipTabButtonImage:(NSTimer*)theTimer;
- (void)resetTabButton;

- (void)fadeAway:(NSTimer*)theTimer;
- (void)resetFading;
- (void)resetFadeTimer;

- (void)computePositions;
- (void)updatePosition;

@end


@implementation ToolDrawerView

#pragma mark
#pragma mark Synthesized fields

@synthesize horizontalCorner;
@synthesize verticalCorner;
@synthesize direction;
@synthesize handleButton;

@synthesize durationToFade;
@synthesize perItemAnimationDuration;

#pragma mark
#pragma mark NSObject lifecycle methods

- (id)initInVerticalCorner:(ToolDrawerVerticalCorner)vCorner andHorizontalCorner:(ToolDrawerHorizontalCorner)hCorner moving:(ToolDrawerDirection)aDirection{
	// The popup toolbar starts off life as a 50.0 x 50.0 view
    if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)])) {
		// It starts off in the close position
        open = NO;
		// Add the chevron button to the view
        [self createTabButton];
        
		// Make sure that the background is clear
		self.opaque = NO;
        
        // Capture the corner and direction of the popup toolbar
        self.verticalCorner = vCorner;
        self.horizontalCorner = hCorner;
        self.direction = aDirection;
        
		// Set the period after which the toolbar should fade
		self.durationToFade = 15.0;
		// Set the per item animation duration
		self.perItemAnimationDuration = 0.3;
        
		// Start the fade timer
        [self resetFadeTimer];
    }
    
    return self;
}

// Draw the white boundry of the popup toolbar
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect iRect = CGRectInset(rect, 0, 0);
    CGFloat tabRadius = 35.0;
    
    // For debug purposes - Draw a red box all the way around the rect
    // CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    // CGContextStrokeRect(ctx, rect);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, iRect.origin.x, iRect.origin.y);
    CGContextAddLineToPoint(ctx, iRect.origin.x, iRect.size.height);
    CGContextAddLineToPoint(ctx, iRect.size.width - tabRadius, iRect.size.height);
    CGContextAddArcToPoint(ctx, iRect.size.width, iRect.size.height, iRect.size.width, iRect.size.height - tabRadius, tabRadius);
    CGContextAddLineToPoint(ctx, iRect.size.width, iRect.origin.y);
    CGContextAddLineToPoint(ctx, iRect.origin.x, iRect.origin.y);
    
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0, 0.65,  // Start color
                 0.0, 0.0, 0.0, 0.95 }; // End color
     
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                      locations, num_locations);
         
    CGPoint startPoint = CGPointMake(iRect.origin.x,iRect.origin.y), 
            endPoint = CGPointMake(iRect.origin.x, iRect.origin.y + iRect.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGContextClipToRect(ctx,iRect);
    CGContextDrawLinearGradient(ctx, myGradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    
    CGContextStrokePath(ctx);
}

#pragma mark
#pragma mark Tab button creation methods 

- (void)createTabButton{
    handleButtonImage = [self createTabButtonImageWithFillColor:[UIColor colorWithWhite:1.0 alpha:0.25]];
    handleButtonBlinkImage = [self createTabButtonImageWithFillColor:[UIColor whiteColor]];
    
    self.handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.handleButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.handleButton.center = CGPointMake(25.0, 25.0);
    self.handleButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.handleButton setImage:handleButtonImage forState:UIControlStateNormal];
    [self.handleButton addTarget:self action:@selector(updatePosition) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.handleButton];
}

// Draw the cheveron button in either the filled or empty state;
- (UIImage *)createTabButtonImageWithFillColor:(UIColor *)fillColor{
    UIGraphicsBeginImageContext(CGSizeMake(24.0, 24.0));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
    
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGRect circle = CGRectMake(2.0, 2.0, 20.0, 20.0);
    // Draw filled circle
    CGContextFillEllipseInRect(ctx, circle);
    
    // Stroke circle
    CGContextAddEllipseInRect(ctx, circle);
    CGContextStrokePath(ctx);
    
    // Stroke Chevron
    CGFloat chevronOffset = 4.0;
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 12.0 - chevronOffset, 12.0 - chevronOffset);
    CGContextAddLineToPoint(ctx, 12.0 + chevronOffset, 12.0);
    CGContextAddLineToPoint(ctx, 12.0 - chevronOffset, 12.0 + chevronOffset);
    CGContextAddLineToPoint(ctx, 12.0 - chevronOffset, 12 - chevronOffset);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return buttonImage;
}


#pragma mark
#pragma mark Tab button blinking methods

- (void)flipTabButtonImage:(NSTimer*)theTimer{
    if (self.handleButton.imageView.image == handleButtonBlinkImage){
        self.handleButton.imageView.image = handleButtonImage;
    } else {
        self.handleButton.imageView.image = handleButtonBlinkImage;
    }
}

- (void)resetTabButton{
    if (handleButtonBlinkTimer != nil){
        if ([handleButtonBlinkTimer isValid]){
            [handleButtonBlinkTimer invalidate];
        }
        
        handleButtonBlinkTimer = nil;
    }
    
    self.handleButton.imageView.image = handleButtonImage;
}

- (void)blinkTabButton{
    handleButtonBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(flipTabButtonImage:)
                                                            userInfo:nil
                                                             repeats:YES];
}

#pragma mark
#pragma mark Toolbar fading methods

- (void)fadeAway:(NSTimer*)theTimer{
    toolDrawerFadeTimer = nil;
    if (self.alpha == 1.0){
        [UIView animateWithDuration:0.5 
							  delay:0.0 
							options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
						 animations:^{ self.alpha = 0.5; }
						 completion:nil];
    }
}

- (void)resetFading{
    [self resetFadeTimer];
    self.alpha = 1.0;
}

- (void)resetFadeTimer{
    [self resetTabButton];
    
    // Make sure to clear out the timer if its running
    if (toolDrawerFadeTimer != nil){
        if ([toolDrawerFadeTimer isValid]){
            [toolDrawerFadeTimer invalidate];
        }
        
        toolDrawerFadeTimer = nil;
    }
    
    // Start the timer again
    toolDrawerFadeTimer = [NSTimer scheduledTimerWithTimeInterval:self.durationToFade
                                                           target:self
                                                         selector:@selector(fadeAway:)
                                                         userInfo:nil
                                                          repeats:NO];
}

#pragma mark
#pragma mark Toolbar Items methods

- (UIButton *)appendItem:(NSString *)imageName{    
    // Load source image / mask from file
    UIImage *maskImage = [UIImage imageNamed:imageName];
    
    // Start a new image context
    UIGraphicsBeginImageContext(maskImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, maskImage.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextClipToMask(ctx, CGRectMake(0.0, 0.0, maskImage.size.width, maskImage.size.height), maskImage.CGImage);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, maskImage.size.width, maskImage.size.height));
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self appendImage:finalImage];
}

- (UIButton *)appendImage:(UIImage *)img{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:img forState:UIControlStateNormal];
    
    [self appendButton:button];
    
    return button;
}

- (void)appendButton:(UIButton *)button{    
    int itemCount = self.subviews.count;
    
    CGRect bounds = self.bounds;
    bounds.size.width += 50.0;
    self.bounds = bounds;
    
    button.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    button.center = CGPointMake(25.0 + (50.0 * (itemCount - 1)), 25.0);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    button.transform = self.transform;
    
    [button addTarget:self action:@selector(resetFading) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:button];
    
    if (self.superview != nil){
        [self computePositions];
    }
}

#pragma mark

- (void)didMoveToSuperview{
    CGRect r = self.superview.bounds;
    CGFloat w = r.size.width / 2.0;
    CGFloat h = r.size.height / 2.0;
    
    CGAffineTransform directionTransform;
    
    if (self.direction == kVertically){
        directionTransform = CGAffineTransformMakeScale(-1.0, 1.0);
        directionTransform = CGAffineTransformConcat(directionTransform, CGAffineTransformMakeRotation(-(M_PI / 2.0)));
    } else {
        directionTransform = CGAffineTransformIdentity;
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.horizontalCorner, self.verticalCorner);
    
    self.transform = CGAffineTransformConcat(directionTransform, scaleTransform);
    
    for(UIView *subview in self.subviews){
        if (subview != handleButton){
            subview.transform = CGAffineTransformInvert(self.transform);
        }
    }
    
    CGAffineTransform screenTransform;
    screenTransform = CGAffineTransformMakeTranslation(-w, -h);
    screenTransform = CGAffineTransformConcat(screenTransform, scaleTransform);
    screenTransform = CGAffineTransformConcat(screenTransform, CGAffineTransformMakeTranslation(w, h));
    
    
    positionTransform = CGAffineTransformConcat(directionTransform, screenTransform);
    
    [self computePositions];
}


#pragma mark
#pragma mark Position Methods

- (bool)isOpen{
    return open;
}

- (void)open{
    if (![self isOpen]){
        [self updatePosition];
    }
}

- (void)close{
    if ([self isOpen]){
        [self updatePosition];
    }
}

- (void)computePositions{
    int itemCount = self.subviews.count - 1;
    
    openPosition = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    closePosition = CGPointMake(openPosition.x - (50.0 * itemCount), openPosition.y);
    
    openPosition = CGPointApplyAffineTransform(openPosition, positionTransform);
    closePosition = CGPointApplyAffineTransform(closePosition, positionTransform);
    
    self.center = closePosition;
}

- (void)updatePosition{
    [self resetFadeTimer];
	NSTimeInterval duration = (self.subviews.count - 1) * self.perItemAnimationDuration;
    [UIView animateWithDuration:duration
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         if ([self isOpen]){
                             self.center = closePosition;
                         } else {
                             self.center = openPosition;
                         }
                         
                         open = !open;
                         
                         // If the toolbar isn't at full brightness, ie alpha = 1.0, set it to 1.0
                         if (self.alpha != 1.0){
                             self.alpha = 1.0;
                         }
                         
                         self.handleButton.transform = CGAffineTransformRotate(self.handleButton.transform, M_PI);
                     }
					 completion:nil];
}

@end