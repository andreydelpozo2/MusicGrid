//
//  HHArcBall.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/31/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHArcBall.h"
#include "ArcBall.h"

@interface HHArcBall()
{
   ArcBallT* _arcBall;
}
@end

@implementation HHArcBall
-(id)init{
   return [self initWithWidth:800 andHeight:600];
}

-(id)initWithWidth:(int)w andHeight:(int)h
{
      if( self = [super init])
      {
         _arcBall = new ArcBallT(w,h);//what are the safest dimentions?
      }
   return self;
}

-(void)dealloc{
   delete _arcBall;
}
@end
