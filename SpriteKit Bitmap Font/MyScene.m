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

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        
        font = [BMGlyphFont fontWithName:@"bmGlyph"];
        label = [BMGlyphLabel labelWithText:@"bmGlyph\nPreview\nText" font:font];
        [label setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];
        [label setHorizontalAlignment:BMGlyphHorizontalAlignmentCentered];
     
        
        
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
        
       
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [label setText:@"Change text"];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
