//
//  SWMGrid.h
//  Life
//
//  Created by Spencer MacKinnon on 2/16/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include "SWMTileSpace.h"

@interface SWMGrid : NSObject {
    NSMutableArray *_tiles;
    GLKVector3 _topLeftBoundary, _topRightBoundary, _bottomLeftBoundary, _bottomRightBoundary;
    float _width, _height;
    int _numberOfTilesWidth, _numberOfTilesHeight;
}

@property NSMutableArray *tiles;
@property GLKVector3 topLeftBoundary, bottomRightBoundary;

- (id)initWithTopLeft:(GLKVector3)topLeft withBottomRight:(GLKVector3)bottomRight;
- (bool)testWithinGridSpace:(CGPoint)point;
- (GLKMatrix4)generateModelViewMatrixForRow:(int)row andColumn:(int)column;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
- (void)setupGL;
- (void)tearDownGL;

@end
