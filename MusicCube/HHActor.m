//
//  HHActor.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHActor.h"

@interface HHActor()
{
    GLKMatrix4 _modelMatrix;
    GLKVector3 _translation;
    GLKMatrix4 _rotationMatrix;
    //scale?
}
@end

@implementation HHActor
@synthesize mesh;
-(void)render
{
    [self.mesh draw];
}

-(void)setRotationMatrix:(GLKMatrix4)rot
{
    _rotationMatrix = rot;
}

-(void)rotateBy:(GLfloat)radians around:(GLKVector3)axis
{
    _rotationMatrix = GLKMatrix4MakeRotation(radians, axis.x, axis.y, axis.z);
}

-(void)translate:(GLKVector3)trans
{
    _translation = trans;
}

-(void)translateX:(GLfloat)x andY:(GLfloat)y andZ:(GLfloat)z
{
    _translation.x = x;
    _translation.y = y;
    _translation.z = z;
}

-(GLKMatrix4)getModelMatrix
{
    
    GLKMatrix4 mt = GLKMatrix4MakeTranslation(_translation.x, _translation.y, _translation.z);
    _modelMatrix = GLKMatrix4Multiply(mt,_rotationMatrix);
    
    return _modelMatrix;
}
@end
