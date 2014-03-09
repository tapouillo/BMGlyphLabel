//
//  BMGlyphFont.h
//  Balloon
//
//  Created by Sebastian Boettcher on 27.10.13.
//  Copyright (c) 2013 Sebastian Boettcher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BMGlyphFont : NSObject <NSXMLParserDelegate>

@property (assign, readonly, nonatomic) NSInteger lineHeight;
@property (strong, readonly, nonatomic) NSMutableDictionary *kernings;
@property (strong, readonly, nonatomic) NSMutableDictionary *chars;
@property (strong, readonly, nonatomic) NSMutableDictionary *charsTextures;
@property (strong, readonly, nonatomic) SKTextureAtlas *textureAtlas;

- (id) initWithName:(NSString *)name;

- (NSInteger) xAdvance:(unichar)charId;
- (NSInteger) xOffset:(unichar)charId;
- (NSInteger) yOffset:(unichar)charId;
- (NSInteger) kerningForFirst:(unichar)first second:(unichar)second;
- (SKTexture*) textureFor:(unichar)charId;

+ (BMGlyphFont*) fontWithName:(NSString *)name;
@end
