/** KempoApi: The Turloc Toolkit *****************************/
/** *    *                                                  **/
/** **  **  Filename: ArcBall.h                             **/
/**   **    Version:  Common                                **/
/**   **                                                    **/
/**                                                         **/
/**  Arcball class for mouse manipulation.                  **/
/**                                                         **/
/**                                                         **/
/**                                                         **/
/**                                                         **/
/**                              (C) 1999-2003 Tatewake.com **/
/**   History:                                              **/
/**   08/17/2003 - (TJG) - Creation                         **/
/**   09/23/2003 - (TJG) - Bug fix and optimization         **/
/**   09/25/2003 - (TJG) - Version for NeHe Basecode users  **/
/**                                                         **/
/*************************************************************/

#ifndef _ArcBall_h
#define _ArcBall_h
#include <assert.h>
#include "matrixDefs.h"

    typedef class ArcBall_t
    {
        protected:
            inline
            void _mapToSphere(const Point2fT* NewPt, Vector3fT* NewVec) const;

        public:
            //Create/Destroy
                    ArcBall_t(GLfloat NewWidth, GLfloat NewHeight);
                   ~ArcBall_t() { /* nothing to do */ };

            //Set new bounds
            inline
            void    setBounds(GLfloat NewWidth, GLfloat NewHeight)
            {
                assert((NewWidth > 1.0f) && (NewHeight > 1.0f));

                //Set adjustment factor for width/height
                this->AdjustWidth  = 1.0f / ((NewWidth  - 1.0f) * 0.5f);
                this->AdjustHeight = 1.0f / ((NewHeight - 1.0f) * 0.5f);
            }

            //Mouse down
            void    click(const Point2fT* NewPt);

            //Mouse drag, calculate rotation
            void    drag(const Point2fT* NewPt, Quat4fT* NewRot);

        protected:
            Vector3fT   StVec;          //Saved click vector
            Vector3fT   EnVec;          //Saved drag vector
            GLfloat     AdjustWidth;    //Mouse bounds width
            GLfloat     AdjustHeight;   //Mouse bounds height

    } ArcBallT;

#endif

