//
//  BMGlyphFont.m
//  Balloon
//
//  Created by Sebastian Boettcher on 27.10.13.
//  Copyright (c) 2013 Sebastian Boettcher. All rights reserved.
//

#import "BMGlyphFont.h"


@interface BMGlyphFont ()
@property (assign, nonatomic) NSInteger lineHeight;
@property (strong, nonatomic) NSMutableDictionary *kernings;
@property (strong, nonatomic) NSMutableDictionary *chars;
@property (strong, nonatomic) NSMutableDictionary *charsTextures;
@property (strong, nonatomic) SKTextureAtlas *textureAtlas;
@end

@implementation BMGlyphFont

+ (BMGlyphFont*) fontWithName:(NSString *)name
{
    return [[BMGlyphFont alloc] initWithName:name];
}

- (id) initWithName:(NSString *)name
{
    if ((self = [super init]))
    {
        self.lineHeight = 0;
        self.kernings = [[NSMutableDictionary alloc] init];
        self.chars = [[NSMutableDictionary alloc] init];
        self.charsTextures = [[NSMutableDictionary alloc] init];
        self.textureAtlas = [SKTextureAtlas atlasNamed:name];
        
        NSString *fontFile = [NSString stringWithFormat:@"%@%@", name, [self getSuffixForDevice]];
        NSString* path = [[NSBundle mainBundle] pathForResource:fontFile ofType: @"xml"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    }
    return self;
}

- (NSString *) getSuffixForDevice
{
    NSString *suffix = @"";
    
#if TARGET_OS_IPHONE
    CGFloat scale;
    if (([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)]))
        scale = [UIScreen mainScreen].nativeScale;
    else
        scale = [UIScreen mainScreen].scale;
    
    if (scale == 2.0)
        suffix = @"@2x";
    else if (scale > 2.0 && scale <= 3.0)
        suffix = @"@3x";
    return suffix;
#else
    return suffix;
#endif
    
}

- (NSInteger) xAdvance:(unichar)charId
{
    return [[self.chars objectForKey:[NSString stringWithFormat:@"xadvance_%i", (int)charId]] integerValue];
}

- (NSInteger) xOffset:(unichar)charId
{
    return [[self.chars objectForKey:[NSString stringWithFormat:@"xoffset_%i", (int)charId]] integerValue];
}

- (NSInteger) yOffset:(unichar)charId
{
    return [[self.chars objectForKey:[NSString stringWithFormat:@"yoffset_%i", (int)charId]] integerValue];
}

- (NSInteger) kerningForFirst:(unichar)first second:(unichar)second
{
    return [[self.kernings objectForKey:[NSString stringWithFormat:@"%i/%i", (int)first, (int)second]] integerValue];
}

- (SKTexture*) textureFor:(unichar)charId
{
    return [self.textureAtlas textureNamed:[NSString stringWithFormat:@"%i", (int)charId]];
}

#pragma mark - NSXMLParser delegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"kerning"])
    {
        NSInteger first  = [[attributeDict valueForKey:@"first"] integerValue];
        NSInteger second = [[attributeDict valueForKey:@"second"] integerValue];
        NSNumber *amount =  [NSNumber numberWithInt:[[attributeDict valueForKey:@"amount"] intValue]];
        [self.kernings setObject:amount forKey:[NSString stringWithFormat:@"%i/%i", (int)first, (int)second]];
    }
    else if ([elementName isEqualToString:@"char"])
    {
        NSInteger charId = [[attributeDict valueForKey:@"id"] integerValue] ;
        NSNumber *xadvance = [NSNumber numberWithInt:[[attributeDict valueForKey:@"xadvance"] intValue]];
        NSNumber *xoffset  = [NSNumber numberWithInt:[[attributeDict valueForKey:@"xoffset"] intValue]];
        NSNumber *yoffset  = [NSNumber numberWithInt:[[attributeDict valueForKey:@"yoffset"] intValue]];
        [self.chars setObject:xoffset forKey:[NSString stringWithFormat:@"xoffset_%i", (int)charId]];
        [self.chars setObject:yoffset forKey:[NSString stringWithFormat:@"yoffset_%i", (int)charId]];
        [self.chars setObject:xadvance forKey:[NSString stringWithFormat:@"xadvance_%i", (int)charId]];
        [self.charsTextures setObject:[self textureFor:charId] forKey:[NSString stringWithFormat:@"%i", (int)charId]];
        
    }
    else if ([elementName isEqualToString:@"common"])
    {
        self.lineHeight = [[attributeDict valueForKey:@"lineHeight"] intValue];
    }
}

@end
