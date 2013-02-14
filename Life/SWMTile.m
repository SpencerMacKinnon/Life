//
//  SWMTile.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMTile.h"

@implementation SWMTile

const int TOTAL_VERTICES = 12;

@synthesize diffuseLightColour;

- (id)init{
    
    self = [super init];
    if (self) {
        float diffuseLightColourBlack[] = {0.0, 0.0, 0.0, 0.0};
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -2.5f);
        
        GLfloat squareVertexData [36]= {
            // Data layout for each line below is:
            // positionX, positionY, positionZ,     normalX, normalY, normalZ,
            
            0.05f, 0.05f, -0.5f,          0.0f, 0.0f, 1.0f,
            -0.05f, 0.05f, -0.5f,         0.0f, 0.0f, 1.0f,
            0.05f, -0.05f, -0.5f,         0.0f, 0.0f, 1.0f,
            0.05f, -0.05f, -0.5f,         0.0f, 0.0f, 1.0f,
            -0.05f, 0.05f, -0.5f,         0.0f, 0.0f, 1.0f,
            -0.05f, -0.05f, -0.5f,        0.0f, 0.0f, 1.0f
            
        };
        
        numberOfVertices = 0;
        
        for (int j = 0; numberOfVertices < TOTAL_VERTICES; numberOfVertices++, j+=3) {
            GLKVector3 vector = GLKVector3Make(squareVertexData[j], squareVertexData[j+1], squareVertexData[j+2]);
            vertex[numberOfVertices] = vector;
        }
        
        [self setDiffuseLightColour:diffuseLightColourBlack];
        [self setModelViewMatrix: &modelViewMatrix];
        
        // Create reference vertex shader path
        vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
        
        // Create reference fragment shader path
        fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
        
    }
    return self;
}

- (id)init2{
    self = [self init];
    if (self) {
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(1.5f, 0.0f, -2.5f);
        [self setModelViewMatrix:&modelViewMatrix];
    }
    
    return self;
}

@end
