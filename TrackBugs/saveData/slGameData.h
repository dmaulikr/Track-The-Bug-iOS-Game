//
//  slGameData.h
//  TrackBugApp
//
//  Created by wenbo on 12/22/15.
//  Copyright © 2015 WenboLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slGameData : NSObject <NSCoding>

@property (assign, nonatomic) long datascore;
@property (assign, nonatomic) long highScore;

@property (strong, nonatomic) UIImage* pilotPhoto;

@property (assign, nonatomic) long countBug;


+(instancetype)sharedGameData;
-(void)reset;
-(void)save;
@end
