//
//  bmGlyphLabel.h
//  SpriteKit Bitmap Font
//
//  Created by Stéphane QUERAUD on 11/10/13.
//  Copyright (c) 2013 Stéphane QUERAUD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BMGlyphFont.h"

typedef enum _BMGlyphHorizontalAlignment
{
    BMGlyphHorizontalAlignmentCentered = 1,
    BMGlyphHorizontalAlignmentRight = 2,
    BMGlyphHorizontalAlignmentLeft = 3
} BMGlyphHorizontalAlignment;

typedef enum _BMGlyphVerticalAlignment
{
    BMGlyphVerticalAlignmentMiddle = 1,
    BMGlyphVerticalAlignmentTop = 2,
    BMGlyphVerticalAlignmentBottom = 3
} BMGlyphVerticalAlignment;

typedef enum _BMGlyphJustify
{
    BMGlyphJustifyLeft = 1,
    BMGlyphJustifyRight = 2,
    BMGlyphJustifyCenter = 3
} BMGlyphJustify;


@interface BMGlyphLabel : SKNode

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BMGlyphHorizontalAlignment horizontalAlignment;
@property (assign, nonatomic) BMGlyphVerticalAlignment verticalAlignment;
@property (assign, nonatomic) BMGlyphJustify textJustify;
@property (nonatomic) SKColor* color;
@property (nonatomic) CGFloat colorBlendFactor;

- (id) initWithText:(NSString *)text font:(BMGlyphFont *)font;

+ (BMGlyphLabel*) labelWithText:(NSString *)text font:(BMGlyphFont *)font;

@end
