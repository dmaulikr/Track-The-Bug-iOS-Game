#import <SpriteKit/SpriteKit.h>

typedef enum : int {
    GameRunning      = 0,
    GameOver         = 1,
    GameWin          = 2,
} GameState;

static long int myScenebugCount;

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKNode *codeLayerNode;
@property (nonatomic, strong) SKNode *hudLayerNode;
@property (nonatomic, strong) SKNode *enemyLayerNode;
@property (nonatomic, strong) SKNode *playerLayerNode;
@property (strong,nonatomic) SKNode *particleLayerNode;
@property (strong,nonatomic) SKNode *starfieldNode;


- (void)increaseScoreBy:(float)increment;
- (void)playExplodeSound;
-(void) shakeScreen;

@end
