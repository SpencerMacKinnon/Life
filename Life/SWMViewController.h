//
//  SWMViewController.h
//  Life
//
//  Created by Spencer MacKinnon on 1/30/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "SWMTile.h"
#import "SWMGrid.h"

@interface SWMViewController : GLKViewController
{
    SWMGrid *_grid;
    GLKMatrix4 _projectionMatrix;
    float _aspect;
}

@end
