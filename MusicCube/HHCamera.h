//
//  HHCamera.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/31/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface HHCamera : NSObject
-(id)init;
-(void)setPerspective:(GLfloat)fov withApect:(GLfloat)ratio nearPlane:(GLfloat)near farPlane:(GLfloat)far;
-(void)translate:(GLKVector3)trans;
-(void)translateX:(GLfloat)x andY:(GLfloat)y andZ:(GLfloat)z;
-(void)rotateAngle:(GLfloat)radians aroundAxis:(GLKVector3)axis;
-(void)setRotationMatrix:(GLKMatrix4)rot;
-(GLKMatrix4)getProjection;
-(GLKMatrix4)getMatrix;
@end
