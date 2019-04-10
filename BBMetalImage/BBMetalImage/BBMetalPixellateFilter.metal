//
//  BBMetalPixellateFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void pixellateKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                            texture2d<half, access::sample> inputTexture [[texture(1)]],
                            device float2 *pixelSize [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= inputTexture.get_width()) || (gid.y >= inputTexture.get_height())) { return; }
    
    const float2 sampleDivisor = float2(*pixelSize);
    const float2 textureCoordinate = float2(float(gid.x) / inputTexture.get_width(), float(gid.y) / inputTexture.get_height());
    const float2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + float2(0.5) * sampleDivisor;
    
    constexpr sampler quadSampler;
    const half4 outColor = inputTexture.sample(quadSampler, samplePos);
    outputTexture.write(outColor, gid);
}