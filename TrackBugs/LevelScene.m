//
//  LevelScene.m
//  TrackBugs
//
//  Created by wenbo on 1/7/16.
//  Copyright © 2016 WenboLiu. All rights reserved.
//

#import "LevelScene.h"
#import "MyScene.h"
#import "slGameData.h"

@implementation LevelScene

- (void)addLevel {
    SKLabelNode *levelTtile = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    levelTtile.text = @"LEVEL1";
    levelTtile.fontSize = 30;
    CGPoint levelTtilePos = CGPointMake(self.size.width/2, self.size.height/4*3);
    levelTtile.position = levelTtilePos;
    levelTtile.name = @"levelTtile";
    levelTtile.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, levelTtile.frame.size.width*1.25, levelTtile.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"levelTtile";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-levelTtile.frame.size.height*1.8,-levelTtile.frame.size.height*0.25);
    [levelTtile addChild:rect];
    
    [self addChild: levelTtile];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self addLevel];
        [self addChild: [self ScoreNode]];
        
    }
    return self;
}

- (SKLabelNode *)ScoreNode
{
    
    SKLabelNode *ScoreNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    ScoreNode.fontSize = 24;
    CGPoint ScoreNodePos = CGPointMake(self.size.width/2, self.size.height/2);
    ScoreNode.position = ScoreNodePos;
    ScoreNode.name = @"ScoreNode";
    ScoreNode.zPosition = 1.0;
    ScoreNode.text =[NSString stringWithFormat:@"High: %li", [slGameData sharedGameData].highScore];
    
    return ScoreNode;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"levelTtile"]) {
        SKAction * buttenAction= [SKAction sequence:@[[SKAction scaleTo:1.2  duration:0.2],[SKAction scaleTo:1 duration:0.2]]];
        [node.parent  runAction:buttenAction completion:^{
            MyScene * myScene= [[MyScene alloc]initWithSize:self.size];
            [self.view presentScene:myScene transition:[SKTransition doorsOpenVerticalWithDuration:1.0]];
        }];
    }

       
}


@end
