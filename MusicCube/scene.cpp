//
//  scene.cpp
//  MusicCube
//
//  Created by Andrey Del Pozo on 5/30/13.
//  Copyright (c) 2013 Andrey Del Pozo. All rights reserved.
//

#include "scene.h"

namespace andrey {

   uint8_t g_CurrId[3] = {0,0,0};
   
   bool genNextId(float id[3])
   {
      if(g_CurrId[0]==255 && g_CurrId[1]==255 && g_CurrId[2] == 255)
         return false;
      
      if(g_CurrId[0]==255)
      {
         g_CurrId[0] = 0;
         if (g_CurrId[1] == 255) {
            g_CurrId[1] = 0;
            g_CurrId[2]++;
         }
         else{
            g_CurrId[1]++;
         }
      }
      else{
         g_CurrId[0]++;
      }
      
      id[0] = g_CurrId[0]/255.0;
      id[1] = g_CurrId[1]/255.0;
      id[2] = g_CurrId[2]/255.0;
      return true;
   }
   
   Scene::Scene()
   {
   }

   Scene::~Scene()
   {
   }
   
   void Scene::addCube(int x, int y)
   {
      _cubes.push_back(Cube(x,y));
   }
   
}