//
//  HHScene.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHActor.h"
#import "HHShaderManager.h"
#import "HHCamera.h"
@interface HHScene : NSObject
@property (weak,nonatomic) HHShaderManager *shaderManager;
@property (weak,nonatomic) HHCamera *camera;
-(id)init;
-(void)setup;
-(void)dealloc;
-(void)addCube:(int)x andy:(int)y;
-(void)addActor:(HHActor*)actor;
-(void)tick;
-(void)render;
@end
