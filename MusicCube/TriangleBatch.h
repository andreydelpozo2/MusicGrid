//
//  TriangleBatch.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float	M3DVector3f[3];		// Vector of three floats (x, y, z)

@interface TriangleBatch : NSObject
@property (nonatomic) int count;
@property (nonatomic) int size;
-(void)draw;
-(void)beginMesh:(int)vertexCount;
-(BOOL)addTriangleVertex:(M3DVector3f [3])pos withNormal:(M3DVector3f [3]) norms;
-(void)endMesh;
-(void)dealloc;
@end
