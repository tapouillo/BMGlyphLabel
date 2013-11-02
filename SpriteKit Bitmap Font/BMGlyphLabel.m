//
//  bmGlyphLabel.m
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 11/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

#import "BMGlyphLabel.h"
#import "BMGlyphFont.h"

@interface BMGlyphLabel ()
@property (assign, nonatomic) CGSize totalSize;
@property (strong, nonatomic) BMGlyphFont *font;
@end

@implementation BMGlyphLabel
@synthesize text = _text;
@synthesize horizontalAlignment = _horizontalAlignment;
@synthesize verticalAlignment = _verticalAlignment;


+ (BMGlyphLabel*) labelWithText:(NSString *)text font:(BMGlyphFont *)font
{
    return [[BMGlyphLabel alloc] initWithText:text font:font];
}

- (id) initWithText:(NSString *)text font:(BMGlyphFont *)font
{
    if ((self = [super init])) {
        self.font = font;
        self.horizontalAlignment = BMGlyphHorizontalAlignmentCentered;
        self.verticalAlignment = BMGlyphVerticalAlignmentMiddle;
        self.totalSize = CGSizeZero;
        self.text = text;
    }
    return self;
}

- (void) setHorizontalAlignment:(BMGlyphHorizontalAlignment)newAlign
{
    if (_horizontalAlignment != newAlign) {
        _horizontalAlignment = newAlign;
        [self positionLabel];
    }
}

- (void) setVerticalAlignment:(BMGlyphVerticalAlignment)newAlign
{
    if (_verticalAlignment != newAlign) {
        _verticalAlignment = newAlign;
        [self positionLabel];
    }
}

- (void) setText:(NSString *)newText
{
    if (![_text isEqualToString:newText]) {
        _text = newText;
        [self updateLabel];
        [self positionLabel];
    }
}

- (void) positionLabel
{
    CGPoint shift = CGPointZero;
    
    switch (self.horizontalAlignment) {
        case BMGlyphHorizontalAlignmentLeft:
            shift.x = 0;
            break;
        case BMGlyphHorizontalAlignmentRight:
            shift.x = -self.totalSize.width;
            break;
        case BMGlyphHorizontalAlignmentCentered:
            shift.x = -self.totalSize.width / 2;
    }
    
    switch (self.verticalAlignment) {
        case BMGlyphVerticalAlignmentBottom:
            shift.y = -self.totalSize.height;
            break;
        case BMGlyphVerticalAlignmentTop:
            shift.y = 0;
            break;
        case BMGlyphVerticalAlignmentMiddle:
            shift.y = -self.totalSize.height / 2;
            break;
    }
    
    
    for (SKSpriteNode *node in [self children]) {
        CGPoint originalPosition = [node.userData[@"originalPosition"] CGPointValue];
        node.position = CGPointMake(originalPosition.x + shift.x, originalPosition.y - shift.y);
    }
}

- (void) updateLabel
{
    unichar lastCharId = 0;
    CGSize size = CGSizeZero;
    CGPoint pos = CGPointZero;
    CGFloat scaleFactor = [UIScreen mainScreen].scale;

    [self removeAllChildren];
    
    if (self.text.length > 0)
        size.height += self.font.lineHeight / scaleFactor;
    
    for (NSUInteger i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex:i];
        if (c == '\n') {
            pos.y -= self.font.lineHeight / scaleFactor;
            size.height += self.font.lineHeight / scaleFactor;
            pos.x = 0;
        } else {
            SKSpriteNode *letter = [SKSpriteNode spriteNodeWithTexture:[self.font textureFor:c]];
            letter.anchorPoint = CGPointZero;
            letter.position = CGPointMake(pos.x + ([self.font xOffset:c] + [self.font kerningForFirst:lastCharId second:c]) / scaleFactor,
                                          pos.y - (letter.size.height + ([self.font yOffset:c]) / scaleFactor));
            letter.userData = [NSMutableDictionary dictionaryWithObject:[NSValue valueWithCGPoint:letter.position] forKey:@"originalPosition"];
            [self addChild:letter];
            
            pos.x += ([self.font xAdvance:c] + [self.font kerningForFirst:lastCharId second:c]) / scaleFactor;
            
            if (size.width < pos.x)
                size.width = pos.x;
        }
        lastCharId = c;
    }
    self.totalSize = size;
}

@end
