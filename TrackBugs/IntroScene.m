//
//  IntroScene.m
//  TrackBugs
//
//  Created by wenbo on 1/7/16.
//  Copyright © 2016 WenboLiu. All rights reserved.
//

#import "IntroScene.h"
#import "LanguageScene.h"
#import "slGameData.h"
#import "UIImage+Mask.h"

@implementation IntroScene
SKNode *node;
SKAction * _startButtonAction;
SKLabelNode* _takePhoto;
SKSpriteNode *_imgBg;

- (void)addGameTitle {
    SKLabelNode *gameTitle = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    gameTitle.text = @"Track The Bug";
    gameTitle.fontSize = 24;
    CGPoint gameTitlePos = CGPointMake(self.frame.size.width /2, self.frame.size.height * 0.75);
    gameTitle.position = gameTitlePos;
    gameTitle.name = @"gameTitle";
    gameTitle.zPosition = 1.0;
    [self addChild: gameTitle];
}

- (SKLabelNode *)startButtonNode
{
    
    SKLabelNode *startNode = [SKLabelNode labelNodeWithFontNamed:@"Thirteen Pixel Fonts"];
    startNode.text = @"START";
    startNode.fontSize = 24;
    startNode.name = @"startNode";
    CGPoint startButtonPos = CGPointMake(self.frame.size.width /2 , self.frame.size.height * 0.5);
    startNode.position = startButtonPos;
    startNode.zPosition = 1.0;
    _startButtonAction = [SKAction repeatActionForever: [SKAction sequence:@[[SKAction fadeOutWithDuration:1.0],[SKAction fadeInWithDuration:1.0]]]];
    SKShapeNode* rect = [SKShapeNode node];
    [rect setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, startNode.frame.size.width*1.25, startNode.frame.size.height*1.5), 3, 3, nil)];
    rect.strokeColor = [SKColor whiteColor];
    rect.lineWidth = 3;
    rect.zPosition =1.0;
    rect.name = @"startNode";
    rect.position = CGPointMake(-CGRectGetMidX(rect.frame)/2-startNode.frame.size.height*1.5,-startNode.frame.size.height*0.25);
    [startNode addChild:rect];

    [startNode runAction:_startButtonAction];
    
    return startNode;
    
}

-(void)addPilotButton{
    _takePhoto = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _takePhoto.name = @"TakePhotoButton";
    _takePhoto.fontSize = 20.0;
    _takePhoto.text = @"PHOTO";
    _takePhoto.position = CGPointMake(self.frame.size.width - _takePhoto.frame.size.width, self.frame.size.height -_takePhoto.frame.size.height - 3);
    
    _takePhoto.fontColor = [SKColor whiteColor];
    [self addChild:_takePhoto];
    
}

-(void)addSpriteImg{
    _imgBg = [SKSpriteNode spriteNodeWithImageNamed:@"Hi.png"];
    _imgBg.size=  CGSizeMake(100, 100);
    
    _imgBg.position = CGPointMake(self.frame.size.width /2 , self.frame.size.height * 0.25);
    [self addChild:_imgBg];
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self addSpriteImg];
        [self setupPilot];
        
        [self addGameTitle];
        [self addChild: [self startButtonNode]];
        [self addPilotButton];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if (n != self && [n.name isEqualToString:@"startNode"]) {
            
            SKAction * buttenAction= [SKAction sequence:@[[SKAction scaleTo:1.2  duration:0.2],[SKAction scaleTo:1 duration:0.2]]];
            [n.parent  runAction:buttenAction completion:^{
                LanguageScene * myLanguageScene = [[LanguageScene alloc]initWithSize:self.size];
                [self.view presentScene:myLanguageScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
            }];
            
            return;
         }
        
        if (n != self && [n.name isEqualToString:@"TakePhotoButton"]) {
            [self takePhoto];
            return;
        }

    
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //1
    lockToPortraitOrientation = NO;
    
    //2
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   NSLog(@"dismiss picker");
                                   
                                   //3
                                   UIImage* photoTaken = info[UIImagePickerControllerOriginalImage];
                                   UIImage* pilotImage = [photoTaken imageWithSize: photoTaken.size andMask:[UIImage imageNamed:@"25_mask.png"]];
                                   
                                   //4
                                   [slGameData sharedGameData].pilotPhoto = pilotImage;
                                   [[slGameData sharedGameData] save];
                                   
                                   //5
                                   [self setupPilot];
                                   
                                   //6
                                   self.paused = NO;
                               }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    lockToPortraitOrientation = NO;
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   self.paused = NO;
                                   NSLog(@"done");
                                   
                               }];
}

-(void)takePhoto
{
    lockToPortraitOrientation = YES;
    
    //1
    self.paused = YES;
    
    //2
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    
    //3
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setAllowsEditing:YES];
    
    imagePickerController.delegate = self;
    
    //4
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController]presentViewController:imagePickerController animated:YES completion:nil];
}


-(void)setupPilot
{
    
    //1
    if ([slGameData sharedGameData].pilotPhoto) {
        //2
        
        UIImage* pilotImage = [[slGameData sharedGameData].pilotPhoto imageWithSize: CGSizeMake(100, 100) andMask:[UIImage imageNamed:@"25_mask.png"]];
        //3
        [[_imgBg childNodeWithName:@"Pilot"] removeFromParent];
        
        //4
        SKTexture* pilotTexture = [SKTexture textureWithImage:pilotImage];
        SKSpriteNode* pilotSprite = [SKSpriteNode spriteNodeWithTexture: pilotTexture];
        pilotSprite.size = pilotTexture.size;
        pilotSprite.name = @"Pilot";
//                pilotSprite.position = CGPointMake(self.frame.size.width /2 , self.frame.size.height * 0.25);
        pilotSprite.position = CGPointMake(0, 0);

        [_imgBg addChild: pilotSprite];
        _imgBg.texture = pilotTexture;

    }
}
-(void)update:(NSTimeInterval)currentTime{
    if (self.paused) {
        return;
    }
}


@end
