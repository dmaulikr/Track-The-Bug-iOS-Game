#import "Player.h"
#import "MyScene.h"

@implementation Player {
  SKEmitterNode *_ventingPlasma;
}

- (instancetype)initWithPosition:(CGPoint)position
{
  if (self = [super initWithPosition:position]) {
    self.name = @"shipSprite";
    
    SKEmitterNode *engineEmitter =
      [NSKeyedUnarchiver unarchiveObjectWithFile:
       [[NSBundle mainBundle] pathForResource:@"touch"
                                       ofType:@"sks"]];
    engineEmitter.position = CGPointMake(1, -4);
    engineEmitter.name = @"engineEmitter";
    [self addChild:engineEmitter];
    
    _ventingPlasma =
      [NSKeyedUnarchiver unarchiveObjectWithFile:
       [[NSBundle mainBundle] pathForResource:@"ventingPlasma"
                                       ofType:@"sks"]];
    _ventingPlasma.hidden = TRUE;
    [self addChild:_ventingPlasma];
    
    [self configureCollisionBody];
  }
  return self;
}

- (void)configureCollisionBody
{
  //    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:[self childNodeWithName:@"shipSprite"].frame.size];
  self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
  
  self.physicsBody.affectedByGravity = NO;
  
  // Set the category of the physics object that will be used for collisions
  self.physicsBody.categoryBitMask = ColliderTypePlayer;
  
  // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
  // set the collisionBitMask to 0
  self.physicsBody.collisionBitMask = 0;
  
  // Make sure we get told about these collisions
  self.physicsBody.contactTestBitMask = ColliderTypeEnemyA|ColliderTypeEnemyB;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
  MyScene * scene = (MyScene *)self.scene;
  [scene playExplodeSound];  
  _ventingPlasma.hidden = self.health > 30;
  
}

- (void)update:(CFTimeInterval)delta
{
  SKEmitterNode *emitter = (SKEmitterNode *) [self childNodeWithName:@"engineEmitter"];
  MyScene * scene = (MyScene *)self.scene;
  if (!emitter.targetNode) {
    emitter.targetNode = [scene particleLayerNode];
  }
}

@end
