//
//  EnemyA.m
//  TrackBugs
//
//  Created by wenbo on 1/16/16.
//  Copyright © 2016 WenboLiu. All rights reserved.
//

#import "GoodCode.h"

@implementation GoodCode

static SKAction *damageAction = nil;
static SKAction *moveBackAction = nil;
static SKAction *removeAction = nil;

#pragma mark -
#pragma mark Class Methods

+ (SKTexture *)generateTexture:(NSString*)text
{
    static SKTexture *texture ;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

            SKLabelNode *goodCode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
            goodCode.name = @"mainshipA";
            goodCode.fontSize = 20.0f;
            goodCode.text = text;
            SKView *textureView = [SKView new];
            texture = [textureView textureFromNode:goodCode];
            texture.filteringMode = SKTextureFilteringNearest;

//    });

    return texture;
}

+ (void)loadSharedAssets
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        damageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.0],
                                            [SKAction colorizeWithColorBlendFactor:0.0 duration:0.3]
                                            ]];
        
        moveBackAction = [SKAction sequence:@[[SKAction moveByX:0 y:20 duration:0.2]]];
        
        removeAction =[SKAction sequence:@[moveBackAction,damageAction,[SKAction removeFromParent]]];
        
    });
}

#pragma mark -
#pragma mark Entity Creation

- (id)initWithPosition:(CGPoint)position
{
    
    if (self = [super initWithPosition:position]) {
        
        self.aiSteering.maxVelocity = 8.0f;
        self.aiSteering.maxSteeringForce = 0.05f;
        
        _score = -445;
        _damageTakenPerShot = 100;
        
        self.physicsBody.categoryBitMask = ColliderTypeEnemyA;
        [GoodCode loadSharedAssets];

    }
    
    return self;
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    [super collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact ];
    NSLog(@" i am good ");
    // Set up an action that will make the entity flash red with damage
    //    [self runAction:damageAction];
    
    // If the entity is moving down the screen then make the ship slow down by moving it back a little with an action
    if (self.aiSteering.currentDirection.y < 0){
        [self runAction:moveBackAction];
    }
//    if (self.health <= 0) {
    self.physicsBody.contactTestBitMask = 0;
    self.physicsBody.categoryBitMask = 0;
//        self.physicsBody.contactTestBitMask = RemoveTypeBody;
        [self runAction: removeAction];

//    －}
    
    MyScene *mainScene = (MyScene*)self.scene;
    [mainScene shakeScreen];
}
@end
