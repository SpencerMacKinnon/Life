//
//  SWMVertexArray.h
//  Life
//
//  Created by Spencer MacKinnon on 2/21/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SWMVertexArray : NSObject {
    NSMutableData *_vertexAndNormal;
    GLuint _vertexBuffer;
    unsigned long _numberOfFloatsInVertices, _sizeOfVerticies;
    int _numberOfVertices;
}

@property unsigned long numberOfFloatsInVertices;
@property unsigned long sizeOfVertices;
@property int numberOfVertices;
@property NSMutableData *vertexData;

@end
