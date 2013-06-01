//
//  HHArcBall.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/31/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "matrixDefs.h"
#include <GLKit/GLKMathTypes.h>

@interface HHArcBall : NSObject
-(id)init;
-(id)initWithWidth:(float)w andHeight:(float)h;
-(void)clickAtPoint:(CGPoint)pt;
-(void)dragToPoint:(CGPoint)pt;
-(GLKMatrix4)getRotation;
@end
