//
//  SWMTileSpace.m
//  Life
//
//  Created by Spencer MacKinnon on 2/17/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMTileSpace.h"

@implementation SWMTileSpace

@synthesize tile=_tile;
@synthesize isActive=_isActive, isActiveNextTurn=_isActiveNextTurn;
@synthesize row=_row, column=_column;

- (id)init{
    
    self = [super init];
    if (self) {
        _tile = [[SWMTile alloc] init];
        _isActive = false;
        _isActiveNextTurn = false;
        _row = 0;
        _column = 0;
    }
    
    return self;
}

@end
