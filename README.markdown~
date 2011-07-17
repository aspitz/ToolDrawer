## SlideRule

SlideRule is a custom UI widget that allows you to have a "slider-like" object 
that can extend beyond the bounds of your window.

## Code Sample

First Example - creates a simple Slide Rule with default parameters.

<code>

	SlideRuleControlView * slideRuler = [[SlideRuleControlView alloc] initWithFrame:CGRectMake(10, 150, 300, 50)];
	CustomSliderTheme * theme = [CustomSliderTheme buildTheme:kCSThemeWhite];
	[view addSubview:slideRuler];
	[slideRuler applyTheme:theme];
	[slideRuler release];	
	
</code>

But more realistically, you might want a label to display the value, set parameters,
and of course apply a theme to the sliderule.

<code>

	
	SlideRuleControlView * slideRuler = [[SlideRuleControlView alloc] initWithFrame:CGRectMake(10, 150, 300, 50) params:parms];
	CustomSliderTheme * theme = [CustomSliderTheme buildTheme:kCSThemeWhite];
	[view addSubview:slideRuler];
	[slideRuler applyTheme:theme];
		

	SlideLabel * label = [[SlideLabel alloc] initWithFrame:CGRectMake(10, 200, 300, 30)];
	[view addSubview:label];
	[label setTextColor:[UIColor lightGrayColor]];
	[slideRuler setSlideDelegate:label];
	[label release];
	
	// update our parameters to change the second slide rule
	parms->minValue = 100.0f;
	parms->maxValue = 400.0f;
	
	SlideRuleControlView * secondSlider = [[SlideRuleControlView alloc] initWithFrame:CGRectMake(10, 300, 300, 50) params:parms];
	[view addSubview:secondSlider];
	[secondSlider setCurrentValue:150.0];
	[secondSlider release];
	
</code>

## Obligatory Screenshot

Here is a screenshot of the sample project, running it "out of the box"

![alt Screenshot](http://www.schazm.com/resources/Screenshot.png "Screenshot")


