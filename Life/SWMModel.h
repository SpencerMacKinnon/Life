//
//  SWMModel.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include "SWMVector3D.h"

@interface SWMModel : NSObject
{
    GLKVector3 vertex[12];
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    unsigned int numberOfVertices;
}

@property (nonatomic) GLKMatrix4 *modelViewMatrix;

- (GLuint) vertShader;
- (GLuint) fragShader;
- (NSMutableData*)vertexData;
- (NSString *) vertShaderPathname;
- (NSString *) fragShaderPathname;
- (unsigned long) sizeOfVertices;
- (unsigned long) numberOfVertices;
- (unsigned long) numberOfFloatsInVertices;

@end
