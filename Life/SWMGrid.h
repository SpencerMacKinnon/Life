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
}

@property NSMutableArray *tiles;

@end
