//
//  SWMGrid.h
//  Life
//
//  Created by Spencer MacKinnon on 2/16/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SWMTile.h"

@interface SWMGrid : NSObject {
    NSMutableArray *_tiles;
    GLKVector3 _topLeftBoundary, _topRightBoundary, _bottomLeftBoundary, _bottomRightBoundary;
}

@property NSMutableArray *tiles;
@property GLKVector3 topLeftBoundary, topRightBoundary, bottomLeftBoundary, bottomRightBoundary;

@end
