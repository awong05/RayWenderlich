//
//  Shaders.metal
//  HelloMetal
//
//  Created by Andy Wong on 12/5/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(
    const device packed_float3* vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 10);
}

fragment half4 basic_fragment() {
    return half4(1.0);
}
