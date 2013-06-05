//
//  HHActor.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHBatch.h"

@interface HHActor : NSObject
@property (strong,nonatomic) HHBatch* mesh;
-(void)render;
-(void)setRotationMatrix:(GLKMatrix4)rot;
-(void)rotateBy:(GLfloat)radians around:(GLKVector3)axis;
-(void)translate:(GLKVector3)trans;
-(void)translateX:(GLfloat)x andY:(GLfloat)y andZ:(GLfloat)z;
-(GLKMatrix4)GetModelMatrix;
@end
