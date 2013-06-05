//
//  HHCamera.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/31/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHCamera.h"

@interface HHCamera()
{
    GLKMatrix4 _projection;
    GLKMatrix4 _camMarix;
    GLKVector3 _translation;
    GLKMatrix4 _rotation;
}
-(void)update;
@end

@implementation HHCamera
-(id)init
{
    if(self = [super init])
    {
        _projection = GLKMatrix4Identity;
        _camMarix = GLKMatrix4Identity;
    }
    
    return self;
}

-(void)setPerspective:(GLfloat)fovInDegrees withApect:(GLfloat)ratio nearPlane:(GLfloat)near farPlane:(GLfloat)far
{
    _projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fovInDegrees), ratio, near, far);
    [self update];
}

-(void)translate:(GLKVector3)trans
{
    _translation = trans;
    [self update];
}

-(void)translateX:(GLfloat)x andY:(GLfloat)y andZ:(GLfloat)z
{
    _translation.x = x;
    _translation.y = y;
    _translation.z = z;
    [self update];
}

-(void)rotateAngle:(GLfloat)radians aroundAxis:(GLKVector3)axis
{
    _rotation = GLKMatrix4MakeRotation(radians, axis.x, axis.y, axis.z);
    [self update];
}

-(void)setRotationMatrix:(GLKMatrix4)rot
{
    _rotation = rot;
    [self update];
}

-(GLKMatrix4)getProjection
{
    return _projection;
}

-(GLKMatrix4)getMatrix
{
    return _camMarix;
}

-(void)update
{
    GLKMatrix4 t = GLKMatrix4MakeTranslation(_translation.x, _translation.y, _translation.z);
    _camMarix = GLKMatrix4Multiply(t,_rotation);
}

@end
