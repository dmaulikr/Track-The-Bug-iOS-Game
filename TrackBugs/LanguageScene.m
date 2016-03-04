//
//  LanguageScene.m
//  TrackBugs
//
//  Created by wenbo on 1/7/16.
//  Copyright © 2016 WenboLiu. All rights reserved.
//

#import "LanguageScene.h"
#import "LevelScene.h"

@implementation LanguageScene
SKShapeNode* rect;
SKLabelNode *languageNode;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self addChild: [self languageButtonNode]];
        [self addChild:[self cPlusPlusButtonNode]];
        [self addChild:[self cSharpButtonNode]];
        [self addChild:[self javaButtonNode]];
        [self addChild:[self swiftButtonNode]];
    }
    return self;
}

-(void)addBorder{
    rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, languageNode.frame.size.width*1.25, languageNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"languageNode";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-languageNode.frame.size.height*3,-languageNode.frame.size.height*0.25);
    [languageNode addChild:rect];

}

- (SKLabelNode *)languageButtonNode
{
    
    languageNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    languageNode.text = @"PROCESSING";
    languageNode.fontSize = 24;
    CGPoint languageNodePos = CGPointMake(self.size.width/2, self.size.height * 0.85);
    languageNode.position = languageNodePos;
    languageNode.name = @"languageNode";
    languageNode.zPosition = 1.0;

    [self addBorder];
    
    return languageNode;
    
}

- (SKLabelNode *)cPlusPlusButtonNode
{
    
    SKLabelNode *cPlusPlusButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    cPlusPlusButtonNode.text = @"C++";
    cPlusPlusButtonNode.fontSize = 24;
    CGPoint languageNodePos = CGPointMake(self.size.width/2, self.size.height * 0.675);
    cPlusPlusButtonNode.position = languageNodePos;
    cPlusPlusButtonNode.name = @"cPlusPlus";
    cPlusPlusButtonNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, languageNode.frame.size.width*1.25, languageNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"cPlusPlus";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-cPlusPlusButtonNode.frame.size.height*3,-cPlusPlusButtonNode.frame.size.height*0.25);
    [cPlusPlusButtonNode addChild:rect];
    
    return cPlusPlusButtonNode;
    
}

- (SKLabelNode *)cSharpButtonNode
{
    
    SKLabelNode *cSharpButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    cSharpButtonNode.text = @"C#";
    cSharpButtonNode.fontSize = 24;
    CGPoint languageNodePos = CGPointMake(self.size.width/2, self.size.height* 0.5);
    cSharpButtonNode.position = languageNodePos;
    cSharpButtonNode.name = @"cSharp";
    cSharpButtonNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, languageNode.frame.size.width*1.25, languageNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"cCharp";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-cSharpButtonNode.frame.size.height*3,-cSharpButtonNode.frame.size.height*0.25);
    [cSharpButtonNode addChild:rect];
    
    return cSharpButtonNode;
    
}

- (SKLabelNode *)javaButtonNode
{
    
    SKLabelNode *javaButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    javaButtonNode.text = @"JAVA";
    javaButtonNode.fontSize = 24;
    CGPoint languageNodePos = CGPointMake(self.size.width/2, self.size.height*0.325);
    javaButtonNode.position = languageNodePos;
    javaButtonNode.name = @"java";
    javaButtonNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, languageNode.frame.size.width*1.25, languageNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"java";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-javaButtonNode.frame.size.height*3,-javaButtonNode.frame.size.height*0.25);
    [javaButtonNode addChild:rect];
    
    return javaButtonNode;
    
}

- (SKLabelNode *)swiftButtonNode
{
    
    SKLabelNode *swiftButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    swiftButtonNode.text = @"SWIFT";
    swiftButtonNode.fontSize = 24;
    CGPoint languageNodePos = CGPointMake(self.size.width/2, self.size.height *0.15);
    swiftButtonNode.position = languageNodePos;
    swiftButtonNode.name = @"swift";
    swiftButtonNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, languageNode.frame.size.width*1.25, languageNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"swift";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-swiftButtonNode.frame.size.height*3,-swiftButtonNode.frame.size.height*0.25);
    [swiftButtonNode addChild:rect];
    
    return swiftButtonNode;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"languageNode"]) {
        SKAction * buttenAction= [SKAction sequence:@[[SKAction scaleTo:1.2  duration:0.2],[SKAction scaleTo:1 duration:0.2]]];
        [node.parent  runAction:buttenAction completion:^{
            LevelScene * myLevelScene= [[LevelScene alloc]initWithSize:self.size];
            [self.view presentScene:myLevelScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        }];

    }
}


@end
