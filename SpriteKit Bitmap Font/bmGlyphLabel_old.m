//
//  bmGlyphLabel.m
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 11/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

#import "bmGlyphLabel.h"

@implementation bmGlyphLabel

-(id) initWithText:(NSString *)txt withAtlas:(NSString *)atlas withFontFile:(NSString *)fntFile
{
    self = [super init];
    
    if (self)
    {
        text = txt;
        lineHeight = 0;
        kernings = [[NSMutableDictionary alloc] init];
        chars = [[NSMutableDictionary alloc] init];
        alignment = bmGlyphAlignmentCentered;
        
        //texture atlas
        SKTextureAtlas *bmGlyphAtlas = [SKTextureAtlas atlasNamed:atlas];
        
        //load xml font file
        NSString* path = [[NSBundle mainBundle] pathForResource: fntFile ofType: @"xml"];
        NSData* data = [NSData dataWithContentsOfFile: path];
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
        [parser setDelegate:self];
        [parser parse];
        
    }
    return self;
}

- (int) xAdvance:(int)charId
{
        NSNumber *value = (NSNumber *)[chars objectForKey:[NSString stringWithFormat:@"xadvance_%i",charId]];
        return [value intValue];
}

- (int) xOffset:(int)charId
{
    NSNumber *value = (NSNumber *)[chars objectForKey:[NSString stringWithFormat:@"xoffset_%i",charId]];
    return [value intValue];
}

- (int) yOffset:(int)charId
{
    NSNumber *value = (NSNumber *)[chars objectForKey:[NSString stringWithFormat:@"yoffset_%i",charId]];
    return [value intValue];
}

- (int) kerningForFirst:(int)f second:(int)s
{
     NSNumber *value = (NSNumber *)[kernings objectForKey:[NSString stringWithFormat:@"%i/%i",f,s]];
     return [value intValue];
}

-(void) setAligment:(bmGlyphAlignment)align
{
    alignment = align;
    [self updateLabel];
    [self positionLabel];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"%@",elementName);
    //NSString* title = [attributeDict valueForKey:@"title"];
    //int id = [[attributeDict valueForKey:@"id"] intValue];
    int first;
    int second;
    int charId;
    NSNumber *amount;
    NSNumber *xadvance;
    NSNumber *xoffset;
    NSNumber *yoffset;
    NSString *tmpKey;
    
    if ([elementName isEqualToString:@"kerning"])
    {
        first = [[attributeDict valueForKey:@"first"] intValue];
        second = [[attributeDict valueForKey:@"second"] intValue];
        amount =  [NSNumber numberWithInt:[[attributeDict valueForKey:@"amount"] intValue] ];
        tmpKey = [NSString stringWithFormat:@"%i/%i",first,second];
        [kernings setObject:amount forKey:tmpKey];
    }
    else if ([elementName isEqualToString:@"char"])
    {
        xadvance = [NSNumber numberWithInt:[[attributeDict valueForKey:@"xadvance"] intValue] ];
        xoffset = [NSNumber numberWithInt:[[attributeDict valueForKey:@"xoffset"] intValue] ];
        yoffset = [NSNumber numberWithInt:[[attributeDict valueForKey:@"yoffset"] intValue] ];
        charId = [[attributeDict valueForKey:@"id"] intValue] ;
        tmpKey = [NSString stringWithFormat:@"xoffset_%i",charId];
        [chars setObject:xoffset forKey:tmpKey];
        tmpKey = [NSString stringWithFormat:@"yoffset_%i",charId];
        [chars setObject:yoffset forKey:tmpKey];
        tmpKey = [NSString stringWithFormat:@"xadvance_%i",charId];
        [chars setObject:xadvance forKey:tmpKey];
    }
    else if ([elementName isEqualToString:@"common"])
    {
        lineHeight = [[attributeDict valueForKey:@"lineHeight"] intValue];
        //NSLog(@"lineHeight: %i",lineHeight);
    }
    
    //end xml parsing: updateLabel
    [self updateLabel];
    [self positionLabel];
}

-(void) setText:(NSString *)txt
{
    totalWidth = 0;
    totalHeight = 0;
    text = txt;
    [self updateLabel];
    [self positionLabel];
    
}

-(void) positionLabel
{
    int shiftX;
    int shiftY;
    
    switch (alignment)
    {
        case bmGlyphAlignmentCentered:
            shiftX = -totalWidth/2;
            break;
            
        case bmGlyphAlignmentLeft:
            shiftX = 0;
            break;
        
        case bmGlyphAlignmentRight:
            shiftX = -totalWidth;
            break;
    }
    //self.position = CGPointMake(0, 0);
    //always ycentered aligned
    shiftY = -totalHeight/2;
   // NSLog(@"%f %i",self.position.x,totalHeight);
    
    for (SKSpriteNode *l in [self children])
    {
        l.position = CGPointMake(l.position.x+shiftX,l.position.y-shiftY);
    }
    
}


-(void) updateLabel
{
    SKSpriteNode *letter;
    SKTexture *texture;
    int xpos = 0;
    int ypos = 0;
    int scaleFactor = 2;
    int lastCharId = 0;
    
    totalWidth = 0;
    totalHeight = lineHeight/scaleFactor;
   
    
    //to do: remove only what is needed and change the existing ones
    [self removeAllChildren];
    
    for(NSUInteger i = 0; i<[text length]; i++)
    {
		unichar c = [text characterAtIndex:i];
        
        if (c == '\n')
        {
            xpos = 0;
            ypos -= lineHeight/scaleFactor;
            totalHeight += lineHeight/scaleFactor;
        }
        else
        {
            texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%i",(int)c]];
            if (texture)
            {
                letter = [SKSpriteNode spriteNodeWithTexture:texture];
                letter.anchorPoint = CGPointMake(0, 0);
                letter.position = CGPointMake(xpos + ([self xOffset:(int)c] + [self kerningForFirst:lastCharId second:(int)c])/scaleFactor, ypos - (letter.size.height + ([self yOffset:(int)c])/scaleFactor));
                [self addChild:letter];
                
                xpos += ([self xAdvance:(int)c] + [self kerningForFirst:lastCharId second:(int)c])/scaleFactor;
                if (totalWidth < xpos)
                    totalWidth = xpos;
                
            }
        }
        lastCharId = (int)c;
    }
    
}

@end
