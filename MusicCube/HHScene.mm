//
//  HHScene.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "HHScene.h"
#import "HHGridActor.h"
#import "HHSolidShapes.h"
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
    GLKVector4 color = {0.0f,1.0f,0.0f,1.0f};
    floor.color = color;
    [self addActor:floor];
    [self addCube:0 andy:0];
}

-(void)addCube:(int)x andy:(int)y
{
    HHActor* cube = [[HHActor alloc]init];
    cube.mesh  = [HHSolidShapes makeCubeWithSide:1.0];
    [cube translateX:3.0f andY:.5f andZ:3.0f];
    GLKVector4 color = {1.0f,0.0f,0.0f,1.0f};
    cube.color = color;

    [self addActor:cube];
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
    GLKMatrix4 base = GLKMatrix4Multiply([self.camera getProjection], [self.camera getMatrix]);
    for(HHActor* act in self.actors)
    {
        GLKMatrix4 mvp = GLKMatrix4Multiply(base, [act getModelMatrix]);
        [self.shaderManager useFlatShaderWithMVP:mvp andColor:act.color];
        [act render];
    }
}
@end
