BMGlyphLabel
=================

This is a class to add the ability to easily add bmGlyph font files to SpriteKit.

Usage: 

	#import "BMGlyphLabel.h"

This will include both the label and the font classes.

You may create font objects like so:

	BMGlyphFont* font = [BMGlyphFont fontWithName:@"bmGlyph"];

It's useful to cache these as the initial load can be slow.

Create labels like this:

	BMGlyphLabel* label = [BMGlyphLabel labelWithText:@"This is a string. Look at it. It's cool. Oooooh pretty fonts." font:font];

Use "\n" in your string to signify a newline.

BMGlyphLabel inherits from SKNode, so you are able to apply any SKNode properties or methods to it (position). It also includes additional functionality, specific to the class:

#### horizontalAlignment *property*
Valid values:

	BMGlyphHorizontalAlignmentCentered,
	BMGlyphHorizontalAlignmentRight,
	BMGlyphHorizontalAlignmentLeft

Usage:

	[label setHorizontalAlignment:BMGlyphHorizontalAlignmentLeft];

If you've ever edited in a word processor before, the values will be fairly self explanatory and I won't waste time nor space to condescend to you. If you haven't, how are you even looking at this right now?! Seriously?!?!!

#### verticalAlignment *property*
Valid values:

	BMGlyphVerticalAlignmentMiddle,
	BMGlyphVerticalAlignmentTop,
	BMGlyphVerticalAlignmentBottom
	
Usage: 

	[label setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];


#### textJustify *property*
Valid values:

	BMGlyphJustifyLeft,
	BMGlyphJustifyRight,
	BMGlyphJustifyCenter
	
Usage: 

	[label setTextJustify:BMGlyphJustifyCenter];


#### color *property*
This is the same usage as SKSpriteNode. SKColor value, etc etc.

Note: I like to make grayscale fonts that I then colorize. They can look very nice if done right.


#### colorBlendFactor *property*
This is the same usage as SKSpriteNode. CGFloat value ranging from 0.0 to 1.0, etc etc.

#### text *property*
NSString object. You can change this to change the text of the label. Radical.



