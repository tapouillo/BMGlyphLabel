//
//  MyScene.m
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 09/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

#import "MyScene.h"
#import "BMGlyphFont.h"
#import "BMGlyphLabel.h"


int i=1;
@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        font = [BMGlyphFont fontWithName:@"chrome"];
        label = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++] font:font];
       
        //possible aligments
        //[label setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];
        //[label setHorizontalAlignment:BMGlyphHorizontalAlignmentLeft];
        //[label setTextJustify:BMGlyphJustifyLeft];
     
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
    }
    return self;
}

#if TARGET_OS_IPHONE

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    label.text =[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++];
    [label setTextJustify:BMGlyphJustifyRight];

}
#else

-(void)mouseDown:(NSEvent *)theEvent {
	
	label.text =[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++];
	[label setTextJustify:BMGlyphJustifyRight];
}

#endif

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    //label.text =[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++];
}

@end
