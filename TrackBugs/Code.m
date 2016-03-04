#import "Code.h"
#import "MyScene.h"
#import "AISteering.h"

@implementation Code

#pragma mark -
#pragma mark Class Methods

SKEmitterNode *_deathEmitter;

+ (SKTexture *)generateTexture: (NSString *)text
{
  // Overridden by subclasses
  return nil;
}

#pragma mark -
#pragma mark Entity Creation

- (id)initWithPosition:(CGPoint)position
{
  if (self = [super initWithPosition:position]) {
    
            NSString * deaultTexture = @"";
            self.texture = [[self class] generateTexture:deaultTexture];
            self.size = self.texture.size;
    self.name = @"enemy";
    
    // Get an initial waypoint
    CGPoint initialWaypoint = CGPointMake(RandomFloatRange(50, 200),
                                          RandomFloatRange(50, 550));
    
    // Setup the steering AI to move to that waypoint
    _aiSteering = [[AISteering alloc] initWithEntity:self waypoint:initialWaypoint];
    
    // Set the initial health of this entity
    self.health = 100;
    self.maxHealth = 100;
    _damageTakenPerShot = 100;
    
    // Load any shared assets that this entity will share with other EnemyA instances

    [self configureCollisionBody];
    
    _deathEmitter = 
    [NSKeyedUnarchiver unarchiveObjectWithFile:
      [[NSBundle mainBundle] pathForResource:@"enemyDeath"
                                    ofType:@"sks"]];
  }
  return self;
}

#pragma mark -
#pragma mark Update

- (void)update:(CFTimeInterval)delta
{
  // Check to see if we have reached the current waypoint and if so set the next one
  if (_aiSteering.waypointReached) {
    [_aiSteering updateWaypoint:
     CGPointMake(RandomFloatRange(100, self.scene.size.width - 100),
                 RandomFloatRange(100, self.scene.size.height - 100))];
  }
  
  // Update the steering AI which will position the entity based on randomly generated waypoints
  [_aiSteering update:delta];
  
}

#pragma mark -
#pragma mark Physics and Collision

- (void)configureCollisionBody
{
  self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
  
  self.physicsBody.affectedByGravity = NO;
    
  // Want to know when a collision happens but we dont want the bodies to actually react to each other so we
  // set the collisionBitMask to 0
  self.physicsBody.collisionBitMask = 0;
  
  // Make sure we get told about these collisions
  self.physicsBody.contactTestBitMask = ColliderTypePlayer ;
  
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    // Remove all the current actions. Their current effect on the enemy ship will remain unchanged so the new action
    // will transition smoothly to the new action
    [self removeAllActions];
    
    // Reduce the health of the enemy ship
    self.health -= _damageTakenPerShot;
    
//     If the enemies health is now below 0 then add the enemyDeath emitter to the scene and reset the enemies position to off screen
    if (self.health <= 0) {
        
        // Reference the main scene
        MyScene *mainScene = (MyScene*)self.scene;
        
        self.health = self.maxHealth;
        [mainScene increaseScoreBy:_score];
        
        _deathEmitter.position = self.position;
        if (!_deathEmitter.parent)
            [mainScene.particleLayerNode addChild:_deathEmitter];
        [_deathEmitter resetSimulation];
        
        [mainScene playExplodeSound];
        
        // Now position the entity above the top of the screen so it can fly into view
        self.position = CGPointMake(RandomFloatRange(100, self.scene.size.width - 100),
                                    self.scene.size.height + 50);
        
    }
    
}


@end
