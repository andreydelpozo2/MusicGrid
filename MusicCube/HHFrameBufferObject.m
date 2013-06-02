//
//  HHFrameBufferObject.m
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/2/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#import "HHFrameBufferObject.h"


bool gltCheckErrors()
{
   bool bFoundError = false;
	GLenum error = glGetError();
   
	if (error != GL_NO_ERROR)
	{
      fprintf(stderr, "A GL Error has occured\n");
      bFoundError = true;
      return false;
	}
#ifndef OPENGL_ES
	GLenum fboStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
   
	if(fboStatus != GL_FRAMEBUFFER_COMPLETE)
	{
      bFoundError = true;
		fprintf(stderr,"The framebuffer is not complete - ");
		switch (fboStatus)
		{
         case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
            // Check the status of each attachment
            fprintf(stderr, "GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT\n");
            break;
         case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
            // Attach at least one buffer to the FBO
            fprintf(stderr, "GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT\n");
            break;
         case GL_FRAMEBUFFER_UNSUPPORTED:
            // Reconsider formats used for attached buffers
            fprintf(stderr, "GL_FRAMEBUFFER_UNSUPPORTED\n");
            break;
         case GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_APPLE:
            // Make sure the number of samples for each
            // attachment is the same
            fprintf(stderr, "GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE\n");
            break;
		}
	}
   
#endif
   
   return bFoundError;
}


const int _surfWidth = 768;
const int _surfHeight = 1024;

@interface HHFrameBufferObject()
{
   GLuint  _fboName;
   GLuint  _mirrorTexture;
   GLuint  _depthBufferName;
   GLint   _iViewport[4];

}
@end

@implementation HHFrameBufferObject
-(void)setup;
{
   glGenFramebuffers(1,&_fboName);
	glBindFramebuffer(GL_FRAMEBUFFER, _fboName);
   

   
   // Create depth renderbuffer
	glGenRenderbuffers(1, &_depthBufferName);
	glBindRenderbuffer(GL_RENDERBUFFER, _depthBufferName);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _surfWidth, _surfHeight );
   
   glGenTextures(1, &_mirrorTexture);
	glBindTexture(GL_TEXTURE_2D, _mirrorTexture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _surfWidth, _surfHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _mirrorTexture, 0);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBufferName);
   
   gltCheckErrors();
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
   
}

-(void)tearDown;
{
   glDeleteTextures(1, &_mirrorTexture);
   glDeleteRenderbuffers(1, &_depthBufferName);
	glDeleteFramebuffers(1, &_fboName);
}

-(void)use
{
         // Viewport in pixels
   glGetIntegerv(GL_VIEWPORT, _iViewport);
   glViewport( 0, 0, _surfWidth, _surfHeight );
   glBindFramebuffer(GL_FRAMEBUFFER, _fboName);
}

-(void)restore
{
   glViewport( 0, 0, _iViewport[2], _iViewport[3] );
   glBindFramebuffer(GL_FRAMEBUFFER, 0);
}
@end
