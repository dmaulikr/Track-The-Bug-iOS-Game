#import "Entity.h"

@implementation Entity

- (instancetype)initWithPosition:(CGPoint)position
{
  if (self = [super init]) {
      
      self.position = position;
      _direction = CGPointZero;
  }
  return self;
}


- (void)update:(CFTimeInterval)delta
{
  // Overridden by subclasses
}

- (void)configureCollisionBody
{
  // Overridden by a subclass
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
  // Overridden by a subclass
}

@end
