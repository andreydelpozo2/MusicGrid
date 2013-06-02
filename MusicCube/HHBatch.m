//
//  HHBatch.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//


//TODO: make use of std::vector

#import "HHBatch.h"

@interface HHBatch()
{
    uint32_t _primitiveType;
    uint32_t _size;
    GLuint   _vertexArrayObject;
    
    GLuint   _uiVertexArray;
    GLKVector3* _pVertex;
    int32_t _nVertsBuilding;
    
    GLuint   _uiNormalArray;
    GLKVector3* _pNormal;
    int32_t _nNormalBuilding;
    
    
}
@end

@implementation HHBatch
-(id)init
{
    if( self = [super init])
    {
        _primitiveType = GL_TRIANGLES;
        _size = 0;
        
        _vertexArrayObject= 0;
        
        _uiVertexArray    = 0;
        _pVertex          = NULL;
        _nVertsBuilding   =0;
        
        _uiNormalArray    = 0;
        _pNormal          = NULL;
        _nNormalBuilding  = 0;
        
    }
    return self;
}

-(void)beginType:(uint32_t)type withSize:(uint32_t)size
{
    _primitiveType = type;
    _size = size;
	glGenVertexArraysOES(1, &_vertexArrayObject);
	glBindVertexArrayOES(_vertexArrayObject);
    
}

-(void)end
{
	// Check to see if items have been added one at a time
	if(_pVertex != NULL) {
		glBindBuffer(GL_ARRAY_BUFFER, _uiVertexArray);
		glUnmapBufferOES(GL_ARRAY_BUFFER);
		_pVertex = NULL;
    }
    
	if(_pNormal != NULL) {
		glBindBuffer(GL_ARRAY_BUFFER, _uiNormalArray);
		glUnmapBufferOES(GL_ARRAY_BUFFER);
		_pNormal = NULL;
    }
    
    // Set up the vertex array object
	glBindVertexArrayOES(_vertexArrayObject);
    
	if(_uiVertexArray !=0) {
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glBindBuffer(GL_ARRAY_BUFFER, _uiVertexArray);
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    }
    
    
	if(_uiNormalArray != 0) {
		glEnableVertexAttribArray(GLKVertexAttribNormal);
		glBindBuffer(GL_ARRAY_BUFFER, _uiNormalArray);
		glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, 0);
    }
    
    glBindVertexArrayOES(0);
}

-(BOOL)addVertex:(GLKVector3)vertex
{
    if(_uiVertexArray == 0) {	// Nope, we need to create it
		glGenBuffers(1, &_uiVertexArray);
		glBindBuffer(GL_ARRAY_BUFFER, _uiVertexArray);
		glBufferData(GL_ARRAY_BUFFER, sizeof(GLKVector3) * _size, NULL, GL_DYNAMIC_DRAW);
    }
    
    if(!_pVertex){
		glBindBuffer(GL_ARRAY_BUFFER, _uiVertexArray);
		_pVertex = (GLKVector3*)glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
        
    }
    
    if(_nVertsBuilding >= _size)
		return NO;
	
	// Copy it in...
	memcpy(&_pVertex[_nVertsBuilding], &vertex, sizeof(GLKVector3));
	_nVertsBuilding++;
    
    return YES;
}

-(BOOL)addNormal:(GLKVector3)normal
{
    if(_uiNormalArray == 0) {	// Nope, we need to create it
		glGenBuffers(1, &_uiNormalArray);
		glBindBuffer(GL_ARRAY_BUFFER, _uiNormalArray);
		glBufferData(GL_ARRAY_BUFFER, sizeof(GLKVector3) * _size, NULL, GL_DYNAMIC_DRAW);
    }
    
    if(!_pNormal){
		glBindBuffer(GL_ARRAY_BUFFER, _uiNormalArray);
		_pNormal = (GLKVector3*)glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
        
    }
    
    if(_nNormalBuilding >= _size)
		return NO;
	
	// Copy it in...
	memcpy(&_pNormal[_nNormalBuilding], &normal, sizeof(GLKVector3));
	_nNormalBuilding++;
    return YES;
}

-(void)draw
{
	glBindVertexArrayOES(_vertexArrayObject);
	glDrawArrays(_primitiveType, 0, _size);
	glBindVertexArrayOES(0);
}

-(void)dealloc
{
    
}

@end
