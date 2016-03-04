#import "MyScene.h"
#import "Player.h"
#import "GoodCode.h"
#import "BugCode.h"
#import "SKTAudio.h"
#import "EndScene.h"
#import "slGameData.h"
#import "IntroScene.h"
#import "UIImage+Mask.h"

@implementation MyScene {
    SKAction *_scoreFlashAction;
    SKLabelNode *_playerHealthLabel;
    NSString    *_healthBar;
    Player *_playerTouch;
    
    CGPoint _deltaPoint;
    CFTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _previousTimeInterval;
    NSTimeInterval _timeInSeconds;
    
    long int _score;
//    int _gameState;
    SKAction *_explodeSound;

    GoodCode *myGoodCode;
    BugCode *myBugCode;
    long int totalEnemyB;
    
}

-(id)initWithSize:(CGSize)size {
   if (self = [super initWithSize:size]) {
    // Configure the physics world
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;

    [self setupSceneLayers];
    [self setupUI];
    [self setupEntities];
    [self addUserImage];
       
    [[SKTAudio sharedInstance] playBackgroundMusic:@"bgMusic.mp3"];
    _explodeSound = [SKAction playSoundFileNamed:@"explode.wav" waitForCompletion:NO];
      
    _timeInSeconds = 10; 

       
}
  return self;
}


- (void)setupSceneLayers
{
  self.starfieldNode = [SKNode node];
  self.starfieldNode.name = @"starfieldNode";
  [self.starfieldNode addChild:[self starfieldEmitterNodeWithSpeed:-20
                 lifetime:(self.frame.size.height / 20)
                    scale:0.2
                birthRate:1
                    color:[SKColor lightGrayColor]]];
  [self.starfieldNode addChild:
  [self starfieldEmitterNodeWithSpeed:-10
                            lifetime:(self.frame.size.height/12)
                               scale:0.14
                           birthRate:1.5
                               color:[SKColor grayColor]]];
  [self.starfieldNode addChild:
  [self starfieldEmitterNodeWithSpeed:-5
                            lifetime:(self.frame.size.height/10)
                               scale:0.10
                           birthRate:2
                               color:[SKColor darkGrayColor]]];

  [self addChild:self.starfieldNode];

  _codeLayerNode = [SKNode node];
  [self addChild:_codeLayerNode];
    
  _playerLayerNode = [SKNode node];
  [self addChild:_playerLayerNode];
    
  _particleLayerNode = [SKNode node];
  [self addChild:_particleLayerNode];
    
  _enemyLayerNode = [SKNode node];
  [self addChild:_enemyLayerNode];

  _hudLayerNode = [SKNode node];
  [self addChild:_hudLayerNode];

}

-(void) shakeScreen {
    CGPoint amount = CGPointMake(RandomFloat() * 20.0f, RandomFloat() * 20.0f);
    SKAction *action =
    [SKAction skt_screenShakeWithNode:self.starfieldNode amount:amount
                         oscillations:10 duration:3.0];
    [self.starfieldNode runAction:action];
}

- (void)setupUI
{
    //add code
    SKLabelNode *codeLabel =[SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    // 2
    codeLabel.fontSize = 20.0;
    codeLabel.text = @"if (x=1){ x=1 } (x=0)";
    codeLabel.name = @"codeLabel";
    // 3
    codeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    // 4
    codeLabel.position = CGPointMake(self.size.width -codeLabel.frame.size.width/2, codeLabel.frame.size.height + 3);
    // 5
    [_codeLayerNode addChild:codeLabel];
    
    int barHeight = 45;
    CGSize backgroundSize =
    CGSizeMake(self.size.width, barHeight);
    
    SKColor *backgroundColor = [SKColor colorWithRed:0 green:0 blue:0.05 alpha:1.0];
    SKSpriteNode *hudBarBackground = [SKSpriteNode spriteNodeWithColor:backgroundColor
                                 size:backgroundSize];
    hudBarBackground.position = CGPointMake(0, self.size.height - barHeight);
    hudBarBackground.anchorPoint = CGPointZero;
    [_hudLayerNode addChild:hudBarBackground];
  
    // 1
    SKLabelNode *scoreLabel =[SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    // 2
    scoreLabel.fontSize = 20.0;
    scoreLabel.text = @"Score: 0";
    scoreLabel.name = @"scoreLabel";
    // 3
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    // 4
    scoreLabel.position = CGPointMake(self.size.width / 2, self.size.height - scoreLabel.frame.size.height + 3);
    // 5
    [_hudLayerNode addChild:scoreLabel];

    _scoreFlashAction = [SKAction sequence:
                     @[[SKAction scaleTo:1.5 duration:0.1],
                       [SKAction scaleTo:1.0 duration:0.1]]];
    [scoreLabel runAction:[SKAction repeatAction:_scoreFlashAction count:10]];
   
  // 1
  _healthBar =
    @"===========================================================================================================";
  float testHealth = 75;
  NSString * actualHealth = [_healthBar substringToIndex:
    (testHealth / 100 * _healthBar.length)];

  // 2
  SKLabelNode *playerHealthBackground = 
    [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
  playerHealthBackground.name = @"playerHealthBackground";
  playerHealthBackground.fontColor = [SKColor darkGrayColor];
  playerHealthBackground.fontSize = 10.0f;
  playerHealthBackground.text = _healthBar;
    
  // 3
  playerHealthBackground.horizontalAlignmentMode = 
    SKLabelHorizontalAlignmentModeLeft;
  playerHealthBackground.verticalAlignmentMode = 
    SKLabelVerticalAlignmentModeTop;
  playerHealthBackground.position = 
    CGPointMake(0, 
                self.size.height - barHeight + 
                  playerHealthBackground.frame.size.height);
  [_hudLayerNode addChild:playerHealthBackground];

  // 4
  _playerHealthLabel = 
    [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
  _playerHealthLabel.name = @"playerHealth";
  _playerHealthLabel.fontColor = [SKColor whiteColor];
  _playerHealthLabel.fontSize = 10.0f;
  _playerHealthLabel.text = actualHealth;
  _playerHealthLabel.horizontalAlignmentMode = 
    SKLabelHorizontalAlignmentModeLeft;
  _playerHealthLabel.verticalAlignmentMode = 
    SKLabelVerticalAlignmentModeTop;
  _playerHealthLabel.position = 
    CGPointMake(0, 
                self.size.height - barHeight + 
                  _playerHealthLabel.frame.size.height);
  [_hudLayerNode addChild:_playerHealthLabel];
  
}

-(void)addUserImage{
    UIImage* pilotImage = [[slGameData sharedGameData].pilotPhoto imageWithSize: CGSizeMake(35, 35) andMask:[UIImage imageNamed:@"25_mask.png"]];
    
    SKTexture* pilotTexture = [SKTexture textureWithImage:pilotImage];
    SKSpriteNode* pilotSprite = [SKSpriteNode spriteNodeWithTexture: pilotTexture];
    pilotSprite.name = @"Pilot";
    pilotSprite.position = CGPointMake(self.frame.size.width -pilotSprite.frame.size.width, self.size.height - pilotSprite.frame.size.height/2);
    [_hudLayerNode addChild: pilotSprite];
   
}

- (void)setupEntities
{
    
      NSArray * goodCodeArray = [NSArray arrayWithObjects:@"if",@"(x==0)",@"{",@"x=1",nil];

      [goodCodeArray enumerateObjectsUsingBlock:
      ^(NSString *goodCode, NSUInteger idx, BOOL *stop) {
          
          myGoodCode = [[GoodCode alloc]initWithPosition:CGPointMake(RandomFloatRange(50, self.size.width - 50), self.size.height + 50)];
          myGoodCode.texture= [GoodCode generateTexture:goodCode];
          myGoodCode.size = myGoodCode.texture.size;

          [_enemyLayerNode addChild:myGoodCode];

      }];
    
    NSArray * bugCodeArray = [NSArray arrayWithObjects:@"y=0;",@";",@"}",nil];
    
    [bugCodeArray enumerateObjectsUsingBlock:
     ^(NSString *texT, NSUInteger idx, BOOL *stop) {
         
     myBugCode = [[BugCode alloc] initWithPosition:CGPointMake(RandomFloatRange(50, self.frame.size.width - 50), self.frame.size.height + 50)];
         myBugCode.texture= [BugCode generateTexture:texT];
         myBugCode.size = myBugCode.texture.size;
         
         [_enemyLayerNode addChild:myBugCode];
         
     }];
    
    totalEnemyB = bugCodeArray.count;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    CGPoint _touchLocation = [[touches anyObject] locationInNode:self];

    _playerTouch = [[Player alloc]
     initWithPosition:_touchLocation];
    [_playerLayerNode addChild:_playerTouch];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{


  CGPoint currentPoint =
    [[touches anyObject] locationInNode:self];
  CGPoint previousPoint = 
    [[touches anyObject] previousLocationInNode:self];
  _deltaPoint = CGPointSubtract(currentPoint, previousPoint);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

  _deltaPoint = CGPointZero;
    [_playerTouch removeFromParent];
}

- (void)touchesCancelled:(NSSet *)touches 
               withEvent:(UIEvent *)event
{

  _deltaPoint = CGPointZero;
    [_playerTouch removeFromParent];

}

- (void)update:(NSTimeInterval)currentTime {
    
    if (_previousTimeInterval==0) {
        _previousTimeInterval = currentTime;
    }
    
//    if (self.paused==YES) {
//        _previousTimeInterval = currentTime;
//        return;
//    }
    
    if (currentTime - _previousTimeInterval > 1) {
        _timeInSeconds -= (int)(currentTime - _previousTimeInterval);
        _previousTimeInterval = currentTime;
    }
    
  // 1
  CGPoint newPoint =
    CGPointAdd(_playerTouch.position, _deltaPoint);

  // 2
  newPoint.x =
    Clamp(newPoint.x,
          _playerTouch.size.width / 2,
          self.size.width - _playerTouch.size.width / 2);
    
  newPoint.y =
    Clamp(newPoint.y,
          _playerTouch.size.height / 2,
          self.size.height - _playerTouch.size.height / 2);
  // 3
  _playerTouch.position = newPoint;
  _deltaPoint = CGPointZero;

  if (_lastUpdateTime) {
    _dt = currentTime - _lastUpdateTime;
  } else {
    _dt = 0;
  }
  _lastUpdateTime = currentTime;
  
  CFTimeInterval timeDelta = currentTime - _lastUpdateTime;
  _lastUpdateTime = currentTime;
    
//    switch (_gameState) {
//    case GameRunning:
//    {
      // Update player
      [_playerTouch update:timeDelta];
      
      // Update all enemies
      [_enemyLayerNode enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
        [(Entity *)node update:timeDelta];
      }];
        
        // Update the healthbar color and length based on the...urm...timer)
        _playerHealthLabel.fontColor = [SKColor colorWithRed:2.0f * (1.0f - _timeInSeconds / 10.0f)
                                                       green:2.0f * _timeInSeconds / 10.0f
                                                        blue:0 alpha:1.0];
        _playerHealthLabel.text = [_healthBar substringToIndex:(_timeInSeconds / 10 * _healthBar.length)];
    
//            if(_score == totalEnemyB * 445){
    NSLog(@"%li",[slGameData sharedGameData].countBug);
    if([slGameData sharedGameData].countBug == totalEnemyB){

//                _gameState = GameWin;
                [self nextSceneWin];

            }else if (_timeInSeconds <= 0) {
//                _gameState = GameOver;
                [self nextSceneOver];
            }
//    }
//    break;
//    case GameOver:
//    {
//      // If the game over message has not been added to the scene yet then add it
//        [_enemyLayerNode enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
//          [(Entity *)node removeFromParent];
//        }];
//        [_playerShip removeFromParent];
//     }
//    }

}

- (void)increaseScoreBy:(float)increment
{
  _score += increment;
    
  SKLabelNode *scoreLabel = (SKLabelNode*)[_hudLayerNode childNodeWithName:@"scoreLabel"];
  scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)_score];
  [scoreLabel removeAllActions];
  [scoreLabel runAction:_scoreFlashAction];
}

- (void)restartGame
{
  // Reset the state of the game
//  _gameState = GameRunning;
  
  // Set up the entities again and the score
  [self setupEntities];
  _score = 0;
 
  _timeInSeconds = 10;
    
  // Reset the score and the players health
  SKLabelNode *scoreLabel = (SKLabelNode *)[_hudLayerNode childNodeWithName:@"scoreLabel"];
  scoreLabel.text = @"Score: 0";
  
  // Remove the game over HUD labels
  [[_hudLayerNode childNodeWithName:@"gameOver"] removeFromParent];
  [[_hudLayerNode childNodeWithName:@"tapScreen"] removeAllActions];
  [[_hudLayerNode childNodeWithName:@"tapScreen"] removeFromParent];
}
-(void)nextSceneOver{
    [slGameData sharedGameData].datascore =_score;
    [slGameData sharedGameData].highScore = MAX([slGameData sharedGameData].datascore,
                                                [slGameData sharedGameData].highScore);
    [[slGameData sharedGameData] save];
    EndScene * myEndSceneOver = [[EndScene alloc] initWithSize:self.size won:NO];
    [self.view presentScene:myEndSceneOver transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
    
}
-(void)nextSceneWin {
    //save score
    [slGameData sharedGameData].datascore =_score;
    [slGameData sharedGameData].highScore = MAX([slGameData sharedGameData].datascore,
                                                [slGameData sharedGameData].highScore);
    [[slGameData sharedGameData] save];

    EndScene * myEndSceneWin = [[EndScene alloc] initWithSize:self.size won:YES];

    [self.view presentScene:myEndSceneWin transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
 
}

#pragma mark -
#pragma mark Physics Contact Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
  
  // Grab the first body that has been involved in the collision and call it's collidedWith method
  // allowing it to react to the collision...
  SKNode *node = contact.bodyA.node;
  if ([node isKindOfClass:[Entity class]]) {
      
    [(Entity*)node collidedWith:contact.bodyB contact:contact];
  }
  
  // ... and do the same for the second body
  node = contact.bodyB.node;
  if ([node isKindOfClass:[Entity class]]) {
    [(Entity*)node collidedWith:contact.bodyA contact:contact];
  }
    
}

- (SKEmitterNode *)starfieldEmitterNodeWithSpeed:(float)speed
                  lifetime:(float)lifetime scale:(float)scale
                birthRate:(float)birthRate color:(SKColor*)color
{

  SKLabelNode *star = 
    [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
  star.fontSize = 50.0f;
  star.text = @"•";

  SKTexture *texture;
  SKView *textureView = [SKView new];
  texture = [textureView textureFromNode:star];
  texture.filteringMode = SKTextureFilteringNearest;

  SKEmitterNode *emitterNode = [SKEmitterNode new];
  emitterNode.particleTexture = texture;
  emitterNode.particleBirthRate = birthRate;
  emitterNode.particleColor = color;
  emitterNode.particleLifetime = lifetime;
  emitterNode.particleSpeed = speed;
  emitterNode.particleScale = scale;
  emitterNode.particleColorBlendFactor = 1;
  emitterNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMaxY(self.frame));
  emitterNode.particlePositionRange =
    CGVectorMake(CGRectGetMaxX(self.frame), 0);
  
  emitterNode.particleAction = [SKAction repeatActionForever:
  [SKAction sequence:@[
    [SKAction rotateToAngle:-M_PI_4 duration:1],
    [SKAction rotateToAngle:M_PI_4 duration:1],
  ]]];
  emitterNode.particleSpeedRange = 20.0;
  
  // 1
  float twinkles = 25;
  SKKeyframeSequence *colorSequence =
    [[SKKeyframeSequence alloc] initWithCapacity:twinkles*2];
  // 2
  float twinkleTime = 1.0/twinkles;
  for (int i = 0; i < twinkles; i++) {

    // 3
    [colorSequence addKeyframeValue:[SKColor whiteColor] time:((i*2)*twinkleTime/2)];
    [colorSequence addKeyframeValue:[SKColor yellowColor] time:((i*2+1)*(twinkleTime/2))];
  }

  // 4
  emitterNode.particleColorSequence = colorSequence;
  
  [emitterNode advanceSimulationTime:lifetime];
  
  return emitterNode;

}

- (void)playExplodeSound {
  [self runAction:_explodeSound];
}

@end
