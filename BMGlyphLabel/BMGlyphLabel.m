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
@synthesize textJustify = _textJustify;

+ (BMGlyphLabel*) labelWithText:(NSString *)text font:(BMGlyphFont *)font
{
    return [[BMGlyphLabel alloc] initWithText:text font:font];
}

- (id) initWithText:(NSString *)text font:(BMGlyphFont *)font
{
    if ((self = [super init]))
    {
        self.font = font;
        self.horizontalAlignment = BMGlyphHorizontalAlignmentCentered;
        self.verticalAlignment = BMGlyphVerticalAlignmentMiddle;
        self.textJustify = BMGlyphJustifyLeft;
        self.totalSize = CGSizeZero;
        self.text = text;
    }
    return self;
}

- (void) setTextJustify:(BMGlyphJustify)newTextJustify
{
    if (_textJustify != newTextJustify)
    {
        _textJustify = newTextJustify;
        [self justifyText];
    }
}

- (void) setHorizontalAlignment:(BMGlyphHorizontalAlignment)newAlign
{
    if (_horizontalAlignment != newAlign)
    {
        _horizontalAlignment = newAlign;
        [self justifyText];

    }
}

- (void) setVerticalAlignment:(BMGlyphVerticalAlignment)newAlign
{
    if (_verticalAlignment != newAlign)
    {
        _verticalAlignment = newAlign;
        [self justifyText];

    }
}

- (void) setText:(NSString *)newText
{
    if (![_text isEqualToString:newText])
    {
        _text = newText;
        [self updateLabel];
        [self justifyText];
    }
}

- (void) positionLabel
{
}

- (void) justifyText
{
    CGPoint shift = CGPointZero;
    
    switch (self.horizontalAlignment)
    {
        case BMGlyphHorizontalAlignmentLeft:
            shift.x = 0;
            break;
        case BMGlyphHorizontalAlignmentRight:
            shift.x = -self.totalSize.width;
            break;
        case BMGlyphHorizontalAlignmentCentered:
            shift.x = -self.totalSize.width / 2;
            break;
    }
    
    switch (self.verticalAlignment)
    {
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
    
    for (SKSpriteNode *node in [self children])
    {
        CGPoint originalPosition = [node.userData[@"originalPosition"] CGPointValue];
        node.position = CGPointMake(originalPosition.x + shift.x, originalPosition.y - shift.y);
    }
    
    if (_textJustify != BMGlyphJustifyLeft)
    {
        int numberNodes = 0;
        int nodePosition = 0;
        int widthForLine = 0;
        unichar c;
        
        SKSpriteNode *node;
        for (NSUInteger i = 0; i <= self.text.length; i++)
        {
            if (i != self.text.length)
                c = [self.text characterAtIndex:i];
            else
                c = '\n';
            if (c == '\n')
            {
                if (numberNodes > 0)
                {
                    while (nodePosition < numberNodes)
                    {
                        node = [[self children] objectAtIndex:nodePosition];
                        if (_textJustify == BMGlyphJustifyRight)
                        {
                            node.position = CGPointMake(node.position.x  + self.totalSize.width - widthForLine +shift.x  ,node.position.y);
                        }
                        else //center
                        {
                            node.position = CGPointMake(node.position.x + (self.totalSize.width - widthForLine)/2 +shift.x/2 ,node.position.y);
                        }
                        nodePosition++;
                    }
                }
                widthForLine = 0;
            }
            else
            {
                node = [[self children] objectAtIndex:numberNodes];
                numberNodes++;
                widthForLine = node.position.x + node.size.width;
            }
        }
    }
}

- (void) updateLabel
{
    unichar lastCharId = 0;
    CGSize size = CGSizeZero;
    CGPoint pos = CGPointZero;
    CGFloat scaleFactor = [UIScreen mainScreen].scale;
    SKSpriteNode *letter;
    
    int childCount = (int)[[self children] count];
    NSUInteger linesCount = [[self.text componentsSeparatedByString:@"\n"] count] - 1;
    
    //remove unused SKSpriteNode
    if (self.text.length - linesCount < childCount && childCount > 0)
    {
        SKSpriteNode *del;
        for (int j=childCount;j>self.text.length-linesCount;j--)
        {
            del = [[self children] objectAtIndex:j-1];
            [del removeFromParent];
        }
    }
    
    
    if (self.text.length > 0)
        size.height += self.font.lineHeight / scaleFactor;
    
    NSUInteger realCharCount = 0;
    for (NSUInteger i = 0; i < self.text.length; i++)
    {
        unichar c = [self.text characterAtIndex:i];
        if (c == '\n')
        {
            pos.y -= self.font.lineHeight / scaleFactor;
            size.height += self.font.lineHeight / scaleFactor;
            pos.x = 0;
        }
        else
        {
            //re-use existing SKSpriteNode and re-assign the correct texture
            if (realCharCount < childCount)
            {
                letter = (SKSpriteNode *)[[self children] objectAtIndex:realCharCount];
                [letter setTexture:[self.font.charsTextures objectForKey:[NSString stringWithFormat:@"%i",c]]];
                [letter setSize:[letter texture].size];
            }
            else //create a new SKSpriteNode and add it as a new child
            {
                letter = [SKSpriteNode spriteNodeWithTexture:[self.font.charsTextures objectForKey:[NSString stringWithFormat:@"%i",c]]];
                [self addChild:letter];
            }
            letter.anchorPoint = CGPointZero;
            letter.position = CGPointMake(pos.x + ([self.font xOffset:c] + [self.font kerningForFirst:lastCharId second:c]) / scaleFactor,  pos.y - (letter.size.height + ([self.font yOffset:c]) / scaleFactor));
            letter.userData = [NSMutableDictionary dictionaryWithObject:[NSValue valueWithCGPoint:letter.position] forKey:@"originalPosition"];
            
            pos.x += ([self.font xAdvance:c] + [self.font kerningForFirst:lastCharId second:c]) / scaleFactor;
            
            if (size.width < pos.x)
                size.width = pos.x;
        
            realCharCount++;
        }
        lastCharId = c;
    }
    self.totalSize = size;
}

@end
