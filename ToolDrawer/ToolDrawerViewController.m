//
//  ToolDrawerViewController.m
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

#import "ToolDrawerViewController.h"
#import "ToolDrawerView.h"

@implementation ToolDrawerViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    ToolDrawerView *toolDrawerView;
    
	UIButton *button;
	
    toolDrawerView = [[ToolDrawerView alloc]initInVerticalCorner:kTopCorner andHorizontalCorner:kLeftCorner moving:kHorizontally];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"A" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"B" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"C" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];    
    [button addTarget:toolDrawerView action:@selector(blinkTabButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:toolDrawerView];
	[toolDrawerView blinkTabButton];
    
    toolDrawerView = [[ToolDrawerView alloc]initInVerticalCorner:kTopCorner andHorizontalCorner:kRightCorner moving:kVertically];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"A" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"B" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"C" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];    
    [self.view addSubview:toolDrawerView];
	
    toolDrawerView = [[ToolDrawerView alloc]initInVerticalCorner:kBottomCorner andHorizontalCorner:kLeftCorner moving:kVertically];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"A" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"B" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"C" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];    
    [self.view addSubview:toolDrawerView];
	
    toolDrawerView = [[ToolDrawerView alloc]initInVerticalCorner:kBottomCorner andHorizontalCorner:kRightCorner moving:kHorizontally];
    [self.view addSubview:toolDrawerView];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"A" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"B" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"C" forState:UIControlStateNormal];
	[toolDrawerView appendButton:button];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
