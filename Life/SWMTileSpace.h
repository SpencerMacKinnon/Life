//
//  SWMTileSpace.h
//  Life
//
//  Created by Spencer MacKinnon on 2/17/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SWMTile.h"

@interface SWMTileSpace : NSObject {
    SWMTile *_tile;
    bool _isActive, _isActiveNextTurn;
    int _row, _column;
}

@property SWMTile *tile;
@property bool isActive, isActiveNextTurn;
@property int row, column;

@end
