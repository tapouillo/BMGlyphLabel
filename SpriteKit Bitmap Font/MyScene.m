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
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        font = [BMGlyphFont fontWithName:@"bmGlyph"];
        label = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++] font:font];
        [label setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];
        [label setHorizontalAlignment:BMGlyphHorizontalAlignmentLeft];
        [label setTextJustify:BMGlyphJustifyLeft];
     
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    label.text =[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++];
    [label setTextJustify:BMGlyphJustifyRight];

}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    //label.text =[NSString stringWithFormat:@"balbal\nscore: %i\nfez",i++];
}

@end
