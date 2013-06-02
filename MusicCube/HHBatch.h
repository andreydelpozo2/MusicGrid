//
//  HHBatch.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface HHBatch : NSObject
-(id)init;
-(void)beginType:(uint32_t)type withSize:(uint32_t)size;
-(void)end;
-(BOOL)addVertex:(GLKVector3)vertex;
-(BOOL)addNormal:(GLKVector3)normal;
-(void)draw;
@end
