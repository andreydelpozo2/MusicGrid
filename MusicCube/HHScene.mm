//
//  HHScene.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHScene.h"
#include "scene.h"

//interface cpp with objc
//http://robnapier.net/blog/wrapping-cppfinal-edition-759

@interface HHScene()
@property (nonatomic) andrey::Scene *scn;
@end


@implementation HHScene

@synthesize scn=_scn;

-(id)init
{
   self = [super init];
   if(self)
   {
      _scn = new andrey::Scene();
   }
   
   return self;
}

-(void)dealloc
{
   delete _scn;
}

-(void)addCube:(int)x andy:(int)y
{
   _scn->addCube(x, y);
}

@end
