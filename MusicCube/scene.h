//
//  scene.h
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#ifndef __MusicCube__scene__
#define __MusicCube__scene__

#include <vector>


namespace andrey {

   bool genNextId(float id[3]);
   
   class Cube
   {
   public:
      Cube():_x(-1),_y(-1){
         genNextId(_id);
      };
      
      Cube(int x,int y):_x(x),_y(y){
         genNextId(_id);
      };
      
      float _id[3];
      uint32_t _x;
      uint32_t _y;
   };
   
   class Scene
   {
   public:
      Scene();
      ~Scene();
      void addCube(int x,int y);
   private:
      std::vector<Cube> _cubes;
   };
   
}

#endif /* defined(__MusicCube__scene__) */
