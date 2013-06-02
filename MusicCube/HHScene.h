//
//  HHScene.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHActor.h"
@interface HHScene : NSObject
-(id)init;
-(void)dealloc;
-(void)addCube:(int)x andy:(int)y;
-(void)addActor:(HHActor*)actor;
-(void)tick;
-(void)render;
@end
