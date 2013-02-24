//
//  SWMGrid.h
//  Life
//
//  Created by Spencer MacKinnon on 2/16/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <stdlib.h>
#include "SWMTileSpace.h"

@interface SWMGrid : NSObject {
    NSMutableArray *_tiles;
    GLKVector3 _topLeftBoundary, _bottomRightBoundary;
    GLuint _vertexBuffer;
    float _width, _height;
    int _numberOfTilesWidth, _numberOfTilesHeight;
    SWMVertexArray *_va;
    SWMShader *_shader;
}

@property NSMutableArray *tiles;
@property GLKVector3 topLeftBoundary, bottomRightBoundary;

- (void)determineNextIteration;
- (BOOL)determineNextIterationForTileWithRow:(int)row andColumn:(int)column cellIsAlive:(bool)cellIsAlive;
- (id)initWithTopLeft:(GLKVector3)topLeft withBottomRight:(GLKVector3)bottomRight;
- (bool)testWithinGridSpace:(CGPoint)point;
- (GLKMatrix4)generateModelViewMatrixForRow:(int)row andColumn:(int)column;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
- (void)setupGL;
- (void)tearDownGL;

@end
