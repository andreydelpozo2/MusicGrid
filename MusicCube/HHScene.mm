//
//  HHScene.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHScene.h"
#import "HHGridActor.h"
#include "scene.h"

//interface cpp with objc
//http://robnapier.net/blog/wrapping-cppfinal-edition-759

@interface HHScene()
@property (nonatomic) andrey::Scene *scn;
@property (strong,nonatomic) NSMutableArray* actors;
@end


@implementation HHScene

@synthesize scn=_scn;

-(id)init
{
   self = [super init];
   if(self)
   {
      _scn = new andrey::Scene();
      self.actors = [NSMutableArray arrayWithCapacity:10];
   }
   
   return self;
}

-(void)dealloc
{
   delete _scn;
}

-(void)setup
{
    HHGridActor *floor = [[HHGridActor alloc]init];
    HHBatch *floorMesh = [[HHBatch alloc ] init];
    [floorMesh beginType:GL_LINES withSize:36];//9x9 grid
    
    GLKVector3 lineFrom = {0.0f,0.0f,0.0f};
    GLKVector3 lineTo = {0.0f,0.0f,0.0f};

    
    //x-z plane
    float step = 0.5f;
    float begin = -2.0f;
    for(int ii=0;ii<9;ii++)
    {
        lineFrom.x = begin+(ii*step); lineFrom.z = begin;
        [floorMesh addVertex:lineFrom];
        
        lineTo.x = begin+(ii*step); lineTo.z = -begin;
        [floorMesh addVertex:lineTo];
        
        lineFrom.x = begin; lineFrom.z = begin+(ii*step);
        [floorMesh addVertex:lineFrom];
        
        lineTo.x = -begin; lineTo.z = begin+(ii*step);
        [floorMesh addVertex:lineTo];
    }
    
    [floorMesh end];
    floor.mesh = floorMesh;
    [self addActor:floor];
}

-(void)addCube:(int)x andy:(int)y
{
   _scn->addCube(x, y);
}

-(void)addActor:(HHActor*)actor
{
   [self.actors addObject:actor];
}

-(void)tick
{
}

-(void)render
{
   for(HHActor* act in self.actors)
   {
      [act render];
   }
}
@end
