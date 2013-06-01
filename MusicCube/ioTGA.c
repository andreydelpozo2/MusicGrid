//
//  ioTGA.c
//  MusicCube
//
//  Created by Andrey Del Pozo on 6/1/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

//#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES2/gl.h>
//#include <OpenGLES/ES2/glext.h>
#include "ioTGA.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

/*
///////////////////////////////////////////////////////
// Macros for big/little endian happiness
// These are intentionally written to be easy to understand what they
// are doing... no flames please on the inefficiency of these.
#ifdef __BIG_ENDIAN__
///////////////////////////////////////////////////////////
// This function says, "this pointer is a little endian value"
// If the value must be changed it is... otherwise, this
// function is defined away below (on Intel systems for example)
inline void LITTLE_ENDIAN_WORD(void *pWord)
{
   unsigned char *pBytes = (unsigned char *)pWord;
   unsigned char temp;
   
   temp = pBytes[0];
   pBytes[0] = pBytes[1];
   pBytes[1] = temp;
}

///////////////////////////////////////////////////////////
// This function says, "this pointer is a little endian value"
// If the value must be changed it is... otherwise, this
// function is defined away below (on Intel systems for example)
inline void LITTLE_ENDIAN_DWORD(void *pWord)
{
   unsigned char *pBytes = (unsigned char *)pWord;
   unsigned char temp;
   
   // Swap outer bytes
   temp = pBytes[3];
   pBytes[3] = pBytes[0];
   pBytes[0] = temp;
   
   // Swap inner bytes
   temp = pBytes[1];
   pBytes[1] = pBytes[2];
   pBytes[2] = temp;
}
#else

// Define them away on little endian systems
#define LITTLE_ENDIAN_WORD
#define LITTLE_ENDIAN_DWORD
#endif

*/
// Define targa header. This is only used locally.
#pragma pack(1)
typedef struct
{
   GLbyte	identsize;              // Size of ID field that follows header (0)
   GLbyte	colorMapType;           // 0 = None, 1 = paletted
   GLbyte	imageType;              // 0 = none, 1 = indexed, 2 = rgb, 3 = grey, +8=rle
   uint16_t	colorMapStart;          // First colour map entry
   uint16_t	colorMapLength;         // Number of colors
   uint8_t 	colorMapBits;   // bits per palette entry
   uint16_t	xstart;                 // image x origin
   uint16_t	ystart;                 // image y origin
   uint16_t	width;                  // width in pixels
   uint16_t	height;                 // height in pixels
   GLbyte	bits;                   // bits per pixel (8 16, 24, 32)
   GLbyte	descriptor;             // image descriptor
} TGAHEADER;
#pragma pack(8)

int gltGrabScreenTGA(const char *szFileName)
{
   FILE *pFile;                // File pointer
   TGAHEADER tgaHeader;		// TGA file header
   unsigned long lImageSize;   // Size in bytes of image
   GLbyte	*pBits = NULL;      // Pointer to bits
   GLint iViewport[4];         // Viewport in pixels
//   GLenum lastBuffer;          // Storage for the current read buffer setting
   
	// Get the viewport dimensions
	glGetIntegerv(GL_VIEWPORT, iViewport);
	
   // How big is the image going to be (targas are tightly packed)
	lImageSize = iViewport[2] * 4 * iViewport[3];
	
   // Allocate block. If this doesn't work, go home
   pBits = (GLbyte *)malloc(lImageSize);
   if(pBits == NULL)
      return 0;
	
   // Read bits from color buffer
   glPixelStorei(GL_PACK_ALIGNMENT, 1);
//	glPixelStorei(GL_PACK_ROW_LENGTH, 0);
//	glPixelStorei(GL_PACK_SKIP_ROWS, 0);
//	glPixelStorei(GL_PACK_SKIP_PIXELS, 0);
   
   // Get the current read buffer setting and save it. Switch to
   // the front buffer and do the read operation. Finally, restore
   // the read buffer state
//   glGetIntegerv(GL_READ_BUFFER, (GLint *)&lastBuffer);
//   glReadBuffer(GL_FRONT);
   glReadPixels(0, 0, iViewport[2], iViewport[3], GL_RGBA, GL_UNSIGNED_BYTE, pBits);
//   glReadBuffer(lastBuffer);
   
   // Initialize the Targa header
   tgaHeader.identsize = 0;
   tgaHeader.colorMapType = 0;
   tgaHeader.imageType = 2;
   tgaHeader.colorMapStart = 0;
   tgaHeader.colorMapLength = 0;
   tgaHeader.colorMapBits = 0;
   tgaHeader.xstart = 0;
   tgaHeader.ystart = 0;
   tgaHeader.width = iViewport[2];
   tgaHeader.height = iViewport[3];
   tgaHeader.bits = 24;
   tgaHeader.descriptor = 0;
   
   // Do byte swap for big vs little endian
#ifdef __APPLE__
#ifdef __BIG_ENDIAN__
   LITTLE_ENDIAN_WORD(&tgaHeader.colorMapStart);
   LITTLE_ENDIAN_WORD(&tgaHeader.colorMapLength);
   LITTLE_ENDIAN_WORD(&tgaHeader.xstart);
   LITTLE_ENDIAN_WORD(&tgaHeader.ystart);
   LITTLE_ENDIAN_WORD(&tgaHeader.width);
   LITTLE_ENDIAN_WORD(&tgaHeader.height);
#endif
#endif
   
   // Attempt to open the file
   pFile = fopen(szFileName, "wb");
   if(pFile == NULL)
   {
      free(pBits);    // Free buffer and return error
      return 0;
   }
	
   // Write the header
   fwrite(&tgaHeader, sizeof(TGAHEADER), 1, pFile);

   // Write the image data
   //fwrite(pBits, lImageSize, 1, pFile);
   
   for(int ii = 0;ii<lImageSize;ii+=4)
   {
      fwrite(pBits+ii, 3, 1, pFile);
   }

   
   // Free temporary buffer and close the file
   free(pBits);
   fclose(pFile);
   
   // Success!
   return 1;
}