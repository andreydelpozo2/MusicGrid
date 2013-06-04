//
//  HHSolidShapes.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHSolidShapes.h"

@implementation HHSolidShapes
+(HHBatch*)makeCubeWithSide:(float)sideLen
{
    HHBatch *mesh = [[HHBatch alloc]init];
    
    [mesh beginType:GL_TRIANGLES withSize:36];

    float fRadius = sideLen * 0.5f;
    GLKVector3 normal;
    GLKVector3 vertex;

    /////////////////////////////////////////////
    // Top of cube

    normal.x = 0.0f; normal.y = 1.0f; normal.z = 0.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];

    vertex.x = fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];

    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];

    vertex.x = fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];

    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];

    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];

    
    ////////////////////////////////////////////
    // Bottom of cube

    normal.x = 0.0f; normal.y = -1.0f; normal.z = 0.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    ///////////////////////////////////////////
    // Left side of cube
    normal.x = -1.0f; normal.y = 0.0f; normal.z = 0.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];

    // Right side of cube
    normal.x = 1.0f; normal.y = 0.0f; normal.z = 0.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    // Front and Back
    // Front
    normal.x = 0.0f; normal.y = 0.0f; normal.z = 1.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = fRadius;
    [mesh addVertex:vertex];

    // Back
    normal.x = 0.0f; normal.y = 0.0f; normal.z = -1.0f;
    for (int ii=0; ii<6; ii++) {
        [mesh addNormal:normal];
    }
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = -fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    vertex.x = fRadius; vertex.y = -fRadius; vertex.z = -fRadius;
    [mesh addVertex:vertex];
    
    
    [mesh end];
    return mesh;
}
@end
