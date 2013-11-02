//
//  bmGlyphLabel.h
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 11/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum
{
    bmGlyphAlignmentCentered = 1,
    bmGlyphAlignmentRight = 2,
    bmGlyphAlignmentLeft = 3,
};
typedef int bmGlyphAlignment;


@interface bmGlyphLabel : SKNode <NSXMLParserDelegate>
{
    NSString *text;
    int lineHeight;
    int totalWidth;
    int totalHeight;
    int alignment;
    
    NSMutableDictionary *kernings;
    NSMutableDictionary *chars;
}

-(id) initWithText:(NSString *)txt withAtlas:(NSString *)atlas withFontFile:(NSString *)fntFile;
-(void) setText:(NSString *)txt;
-(void) setAligment:(bmGlyphAlignment)align;
-(void) updateLabel;
@end
