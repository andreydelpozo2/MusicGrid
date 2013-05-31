//
//  TriangleBatch.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "TriangleBatch.h"
#import <GLKit/GLKit.h>

#define SAFE_FREE(x) if(x){free(x);x=NULL;}
void normalizeVector(M3DVector3f v )
{
   float len = 1.0f/sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
   v[0] *= len;
   v[1] *= len;
   v[2] *= len;
}

@interface TriangleBatch()
{
   M3DVector3f *_pVerts;        // Array of vertices
   M3DVector3f *_pNorms;        // Array of normals
   GLuint _vertexArray;
   GLuint _vertexBuffer;
   GLuint _normalBuffer;
}
@end

@implementation TriangleBatch

-(void)beginMesh:(int)vertexCount
{
   _size = vertexCount;
   _count = 0;
   _pVerts = (M3DVector3f*)malloc(_size * sizeof(M3DVector3f));
   _pNorms = (M3DVector3f*)malloc(_size * sizeof(M3DVector3f));
}

-(void)endMesh
{
   glGenVertexArraysOES(1, &_vertexArray);
   glBindVertexArrayOES(_vertexArray);

   glGenBuffers(1, &_vertexBuffer);
   glGenBuffers(1, &_normalBuffer);
   
   glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
   glEnableVertexAttribArray(GLKVertexAttribPosition);
   glBufferData(GL_ARRAY_BUFFER, _count*sizeof(M3DVector3f), _pVerts, GL_STATIC_DRAW);
   glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
   
   glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
   glEnableVertexAttribArray(GLKVertexAttribNormal);
   glBufferData(GL_ARRAY_BUFFER, _count*sizeof(M3DVector3f), _pNorms, GL_STATIC_DRAW);
   glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, 0);
   
   glBindVertexArrayOES(0);
   
//   _count = 0;
   _size = 0;
   SAFE_FREE(_pVerts);
   SAFE_FREE(_pNorms);
}

-(BOOL)addTriangleVertex:(M3DVector3f [3])pos withNormal:(M3DVector3f [3]) norms
{
   if(_count+3 >= _size)
      return FALSE;
   
   normalizeVector(norms[0]);
   normalizeVector(norms[1]);
   normalizeVector(norms[2]);
   

   for(int ii=0;ii<3;ii++){
      memcpy(_pVerts[_count],pos[ii],sizeof(M3DVector3f));
      memcpy(_pNorms[_count],norms[ii],sizeof(M3DVector3f));
      _count++;
   }

   return TRUE;
}

//glEnableClientState??
-(void)draw
{

	glBindVertexArrayOES(_vertexArray);
   
   glDrawArrays(GL_TRIANGLES, 0, _count);
   
	glBindVertexArrayOES(0);
}

-(void)dealloc
{
   glDeleteBuffers(1, &_vertexBuffer);
   glDeleteBuffers(1, &_normalBuffer);
   glDeleteVertexArraysOES(1, &_vertexArray);
   
   SAFE_FREE(_pVerts);
   SAFE_FREE(_pNorms);
}

@end
