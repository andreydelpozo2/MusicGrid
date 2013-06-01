//
//  HHArcBall.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/31/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHArcBall.h"
#include "ArcBall.h"
#include <GLKit/GLKMatrix4.h>

@interface HHArcBall()
{
   ArcBallT* _arcBall;
   Matrix3fT   _lastRot;
   Matrix3fT   _thisRot;
   GLKMatrix4   _transform; //make property?
}
@end

@implementation HHArcBall
-(id)init{
   //what are the safest dimentions?
   return [self initWithWidth:800 andHeight:600];
}

-(id)initWithWidth:(float)w andHeight:(float)h
{
      if( self = [super init])
      {
         _arcBall = new ArcBallT(w,h);
         Matrix3fSetIdentity(&(_lastRot));
         Matrix3fSetIdentity(&(_thisRot));
         _transform = GLKMatrix4Identity;
      }
   return self;
}

-(void)dealloc{
   delete _arcBall;
}

-(GLKMatrix4)getRotation
{
   return _transform;
}

-(void)clickAtPoint:(CGPoint)p
{
   if(_arcBall == NULL)
      return;
   
   _lastRot = _thisRot;
   Tuple2fT pt;
   pt.s.X = p.x;
   pt.s.Y = p.y;
   _arcBall->click(&pt);
}

-(void)dragToPoint:(CGPoint)p
{
   if(_arcBall == NULL)
      return;
   
   Quat4fT thisQuat;
   Tuple2fT pt;
   pt.s.X = p.x;
   pt.s.Y = p.y;
   _arcBall->drag(&pt,&thisQuat);
   Matrix3fSetRotationFromQuat4f(&_thisRot, &thisQuat);		// Convert Quaternion Into Matrix3fT
   Matrix3fMulMatrix3f(&_thisRot, &_lastRot);				// Accumulate Last Rotation Into This One
   Matrix4fT trans;
   Matrix4fSetIdentity(&(trans));
   Matrix4fSetRotationFromMatrix3f(&trans, &_thisRot);	// Set Our Final Transform's Rotation From This One
   
   memcpy(_transform.m, trans.M, sizeof(_transform.m));
   
}

@end
