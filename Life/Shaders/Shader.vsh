//
//  Shader.vsh
//  Life
//
//  Created by Spencer MacKinnon on 1/30/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 diffuseColour;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    colorVarying = diffuseColour * nDotVP;
    
    gl_Position = modelViewProjectionMatrix * position;
}
