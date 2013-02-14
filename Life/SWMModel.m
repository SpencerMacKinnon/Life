//
//  SWMModel.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMModel.h"

@implementation SWMModel

@synthesize modelViewMatrix;

-(id)init{
    self = [super init];
    if (self){
        numberOfVertices = 0;
    }
    
    return self;
}

- (NSMutableData*)vertexData{
    
    int verticeByteSize = sizeof(vertex);
    
    NSMutableData *vertexData = [NSMutableData dataWithCapacity:verticeByteSize];
    
    for (int i=0; i < numberOfVertices; i++) {
        [vertexData appendBytes:&vertex[i].x length:sizeof(float)];
        [vertexData appendBytes:&vertex[i].y length:sizeof(float)];
        [vertexData appendBytes:&vertex[i].z length:sizeof(float)];
    }
    
    return vertexData;
}

- (unsigned long)sizeOfVertices {
    
    return sizeof(vertex);
}

- (unsigned long)numberOfVertices {
    return numberOfVertices;
}

- (unsigned long)numberOfFloatsInVertices {
    return 3 * [self numberOfVertices];
}

- (GLuint)vertShader {
    return vertShader;
}

- (GLuint)fragShader {
    return fragShader;
}

- (NSString *)vertShaderPathname {
    return vertShaderPathname;
}

- (NSString *)fragShaderPathname {
    return fragShaderPathname;
}

@end
