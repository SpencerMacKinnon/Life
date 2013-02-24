//
//  SWMVertexArray.m
//  Life
//
//  Created by Spencer MacKinnon on 2/21/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMVertexArray.h"

@implementation SWMVertexArray

@synthesize numberOfFloatsInVertices = _numberOfFloatsInVertices;
@synthesize sizeOfVertices = _sizeOfVerticies;
@synthesize vertexData = _vertexAndNormal;
@synthesize numberOfVertices = _numberOfVertices;

- (id)init{
    self = [super init];
    if (self) {
        
        GLfloat squareVertexData [36]= {
            // Data layout for each line below is:
            // positionX, positionY, positionZ,     normalX, normalY, normalZ,
            
            0.003f, 0.0f, -0.1f,          0.0f, 0.0f, 1.0f,
            0.0f, 0.0f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.003f, -0.003f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.003f, -0.003f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.0f, 0.0f, -0.1f,         0.0f, 0.0f, 1.0f,
            0.0f, -0.003f, -0.1f,        0.0f, 0.0f, 1.0f
            
        };
        
        _sizeOfVerticies = sizeof(squareVertexData);
        _vertexAndNormal = [[NSMutableData alloc] initWithBytes:squareVertexData length:_sizeOfVerticies];
        _numberOfFloatsInVertices = 36;
        _numberOfVertices = 6;
    }
    
    return self;
}

@end
