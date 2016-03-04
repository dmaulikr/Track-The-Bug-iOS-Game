//
//  slGameData.m
//  TrackBugApp
//
//  Created by wenbo on 12/22/15.
//  Copyright © 2015 WenboLiu. All rights reserved.
//

#import "slGameData.h"

@implementation slGameData

static NSString* const SLGameDataHighScoreKey = @"highScore";
static NSString* const SLGameDataScoreKey = @"score";
static NSString* const SSGameDataPilotPhotoKey = @"pilotPhoto";

static NSString* const SLGameDataBugCountKey = @"bugCount";


//encode
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: SLGameDataHighScoreKey];
    [encoder encodeDouble:self.datascore forKey: SLGameDataScoreKey];
    [encoder encodeDouble:self.countBug forKey: SLGameDataBugCountKey];

    if (self.pilotPhoto) {
        NSData* imageData = UIImagePNGRepresentation(self.pilotPhoto);
        [encoder encodeObject:imageData forKey: SSGameDataPilotPhotoKey];
    }
}
//decode
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: SLGameDataHighScoreKey];
        _datascore = [decoder decodeDoubleForKey: SLGameDataScoreKey];
        _countBug =[decoder decodeDoubleForKey:SLGameDataBugCountKey];
        
        NSData* imageData = [decoder decodeObjectForKey: SSGameDataPilotPhotoKey];
        if (imageData) {
            _pilotPhoto = [[UIImage alloc] initWithData:imageData];
        }
    }
    return self;
}

//access to this class’ singleton instance
+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

//reset
-(void)reset
{
    self.datascore = 0;
    self.countBug = 0;
}

//file path
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

//load
+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [slGameData filePath]];
    if (decodedData) {
        slGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[slGameData alloc] init];
}

//save
-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[slGameData filePath] atomically:YES];
}

@end
