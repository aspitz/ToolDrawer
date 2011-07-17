
//
//  PopupToolbarView.m
//
//  Created by Ayal Spitz on 10/6/10.
//  Copyright (c) 2010 MITRE Corp. All rights reserved.
//

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
@synthesize tabButton;

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
		durationToFade = 5.0;
		// Set the per item animation duration
		perItemAnimationDuration = 0.3;

		// Start the fade timer
        [self resetFadeTimer];
    }

    return self;
}

// Draw the white boundry of the popup toolbar
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect iRect = CGRectInset(rect, 1, 1);
    CGFloat tabRadius = 35.0;
    
    // For debug purposes - Draw a red box all the way around the rect
    // CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    // CGContextStrokeRect(ctx, rect);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, iRect.origin.x, iRect.origin.y);
    CGContextAddLineToPoint(ctx, iRect.origin.x, iRect.size.height);
    CGContextAddLineToPoint(ctx, iRect.size.width - tabRadius, iRect.size.height);
    CGContextAddArcToPoint(ctx, iRect.size.width, iRect.size.height, iRect.size.width, iRect.size.height - tabRadius, tabRadius);
    CGContextAddLineToPoint(ctx, iRect.size.width, iRect.origin.y);
    CGContextAddLineToPoint(ctx, iRect.origin.x, iRect.origin.y);
    CGContextStrokePath(ctx);
}

#pragma mark
#pragma mark Tab button creation methods 

- (void)createTabButton{
    tabButtonImage = [self createTabButtonImageWithFillColor:[UIColor colorWithWhite:1.0 alpha:0.25]];
    tabButtonBlinkImage = [self createTabButtonImageWithFillColor:[UIColor whiteColor]];
                            
    self.tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tabButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.tabButton.center = CGPointMake(25.0, 25.0);
    self.tabButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.tabButton setImage:tabButtonImage forState:UIControlStateNormal];
    [self.tabButton addTarget:self action:@selector(updatePosition) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.tabButton];
}

// Draw the cheveron button in either the filled or empty state;
- (UIImage *)createTabButtonImageWithFillColor:(UIColor *)fillColor{
    UIGraphicsBeginImageContext(CGSizeMake(24.0, 24.0));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
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
    CGContextStrokePath(ctx);
    
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return buttonImage;
}


#pragma mark
#pragma mark Tab button blinking methods

- (void)flipTabButtonImage:(NSTimer*)theTimer{
    if (self.tabButton.imageView.image == tabButtonBlinkImage){
        self.tabButton.imageView.image = tabButtonImage;
    } else {
        self.tabButton.imageView.image = tabButtonBlinkImage;
    }
}
 
- (void)resetTabButton{
    if (tabButtonBlinkTimer != nil){
        if ([tabButtonBlinkTimer isValid]){
            [tabButtonBlinkTimer invalidate];
        }
        
        tabButtonBlinkTimer = nil;
    }
    
    self.tabButton.imageView.image = tabButtonImage;
}

- (void)blinkTabButton{
    tabButtonBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(flipTabButtonImage:)
                                                         userInfo:nil
                                                          repeats:YES];
}

#pragma mark
#pragma mark Toolbar fading methods

- (void)fadeAway:(NSTimer*)theTimer{
    toolbarFadeTimer = nil;
    if (self.alpha == 1.0){
        [UIView animateWithDuration:0.5 
							  delay:0.0 
							options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
						 animations:^{ self.alpha = 0.2; }
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
    if (toolbarFadeTimer != nil){
        if ([toolbarFadeTimer isValid]){
            [toolbarFadeTimer invalidate];
        }
    
        toolbarFadeTimer = nil;
    }
    
    // Start the timer again
    toolbarFadeTimer = [NSTimer scheduledTimerWithTimeInterval:durationToFade
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
        if (subview != tabButton){
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
	NSTimeInterval duration = (self.subviews.count - 1) * perItemAnimationDuration;
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
                         
                         self.tabButton.transform = CGAffineTransformRotate(self.tabButton.transform, M_PI);
                     }
					 completion:nil];
}

@end
