#import "Entity.h"

@class AISteering;

@interface Code : Entity {
    int         _score;
    int         _damageTakenPerShot;
}

@property (strong,nonatomic) AISteering *aiSteering;
+ (SKTexture *)generateTexture:(NSString*)text;

@end
