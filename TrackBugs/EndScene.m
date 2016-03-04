//
//  EndScene.m
//  TrackBugs
//
//  Created by wenbo on 1/7/16.
//  Copyright © 2016 WenboLiu. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"
#import "slGameData.h"

@implementation EndScene

SKAction    *_gameOverPulse;
SKLabelNode *_gameOverLabel;
SKLabelNode *_tapScreenLabel;
SKAction * playAgainButtonAction;
SKLabelNode *playAgainNode;
SKColor *newColor;

- (void)addWinTitle {
    SKLabelNode * winTitle = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    winTitle.text = @"BUG CLEAR";
    winTitle.fontSize = 40.0f;
    CGPoint winTitlePos = CGPointMake(self.size.width/2, self.size.height/5*4);
    winTitle.position =winTitlePos;
    winTitle.name = @"winTitle";
    winTitle.fontColor = newColor;
    winTitle.zPosition = 1.0;
    [self addChild: winTitle];
}

- (void)addScoreWin {
    SKLabelNode * scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    
    scoreNode.text = [NSString stringWithFormat:@"Your Score: %li",[slGameData sharedGameData].datascore];
    [[slGameData sharedGameData] reset];    scoreNode.fontSize = 30;
    
    CGPoint scoreNodePos = CGPointMake(self.size.width/2, self.size.height/5*3);
    scoreNode.position =scoreNodePos;
    scoreNode.name = @"scoreNode";
    scoreNode.zPosition = 1.0;
    [self addChild: scoreNode];
}

- (void)addLoseTitle {
    
    _gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    _gameOverLabel.name = @"gameOver";
    _gameOverLabel.fontSize = 40.0f;
    _gameOverLabel.fontColor = [SKColor whiteColor];
    _gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _gameOverLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _gameOverLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 4 * 3);
    _gameOverLabel.text = @"GAME OVER";
    [self addChild:_gameOverLabel];
   
    _gameOverLabel.fontColor = newColor;
}

- (void)addScoreLose {
    SKLabelNode * scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    
    scoreNode.text = [NSString stringWithFormat:@"Your Score: %li",[slGameData sharedGameData].datascore];
    [[slGameData sharedGameData] reset];
    
    scoreNode.fontSize = 30;
    CGPoint scoreNodePos = CGPointMake(self.size.width/2, self.size.height/2);
    scoreNode.position =scoreNodePos;
    scoreNode.name = @"scoreNode";
    scoreNode.zPosition = 1.0;
    [self addChild: scoreNode];
}

- (id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
        _gameOverPulse = [SKAction repeatActionForever: [SKAction sequence:@[[SKAction fadeOutWithDuration:1.0],[SKAction fadeInWithDuration:1.0]]]];
        playAgainButtonAction = [SKAction repeatActionForever: [SKAction sequence:@[[SKAction fadeOutWithDuration:1.0],[SKAction fadeInWithDuration:1.0]]]];
        
        newColor = [SKColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
       
        if (won) {
            
            [self addScoreWin];
            [self addWinTitle];
            [self addChild: [self nextButtonNode]];
            [self addChild: [self playAgainButtonNode:YES]];
            
        } else {
            [self addScoreLose];
            [self addLoseTitle];
            [self addChild: [self playAgainButtonNode:NO]];
            
        }
        
    }
    return self;
}

- (SKLabelNode *)nextButtonNode
{
    
    SKLabelNode *nextButtonNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    nextButtonNode.text = @"NEXT LEVEL";
    nextButtonNode.fontSize = 24;
    CGPoint nextButtonNodePos = CGPointMake(self.size.width/2, self.size.height*0.15);
    nextButtonNode.position = nextButtonNodePos;
    nextButtonNode.name = @"nextButtonNode";
    nextButtonNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, nextButtonNode.frame.size.width*1.25, nextButtonNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"nextButtonNode";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-nextButtonNode.frame.size.height*3,-nextButtonNode.frame.size.height*0.25);
    [nextButtonNode addChild:rect];
    
    return nextButtonNode;
    
}

- (SKLabelNode *)playAgainButtonNode: (BOOL)won
{
    
    SKLabelNode *playAgainNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    playAgainNode.text = @"PLAY AGAIN";
    playAgainNode.fontSize = 24;
    CGPoint playAgainNodePos = CGPointMake(self.size.width/2, self.size.height*0.3);
    playAgainNode.position = playAgainNodePos;
    playAgainNode.name = @"playAgainNode";
    playAgainNode.zPosition = 1.0;
    
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, playAgainNode.frame.size.width*1.25, playAgainNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"playAgainNode";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-playAgainNode.frame.size.height*3,-playAgainNode.frame.size.height*0.25);
    [playAgainNode addChild:rect];
    
    if (!won) {
        [playAgainNode runAction:playAgainButtonAction];
    }else{
        
    }
    
    return playAgainNode;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"playAgainNode"]) {
            SKAction * buttenAction= [SKAction sequence:@[[SKAction scaleTo:1.2  duration:0.2],[SKAction scaleTo:1 duration:0.2]]];
            [node.parent  runAction:buttenAction completion:^{
                MyScene * myScene = [[MyScene alloc]initWithSize:self.size];
                [self.view presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
            }];
       
    }
    if ([node.name isEqualToString:@"nextButtonNode"]) {
        NSLog(@"NextLevel");
    }
}


@end
