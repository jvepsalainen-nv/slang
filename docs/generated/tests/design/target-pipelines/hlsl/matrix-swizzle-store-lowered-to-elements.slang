//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#requiredloweringpassset-flags
//META: purpose=A matrix swizzle on the left of an assignment sets the `matrixSwizzleStore` gate that selects `lowerMatrixSwizzleStores`, so `m._m00_m11 = v;` reaches HLSL as one indexed element assignment per swizzled component rather than as a swizzle.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the emit-visible consequence of the `matrixSwizzleStore`
// gate row. The `_m00_m11` diagonal is deliberately non-contiguous
// so the lowering cannot be mistaken for a whole-row or whole-column
// store: the CHECKs assert two separate `[row][col]` assignments
// naming the exact indices, and that no `_m00` swizzle spelling
// survives. The stored value comes from a uniform so the assignment
// is not constant-folded, and the whole matrix is written to the
// output buffer so neither element is dead.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<float4> outBuf;
uniform float2 v;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float2x2 m = float2x2(0, 0, 0, 0);
    m._m00_m11 = v;
    outBuf[tid.x] = float4(m[0], m[1]);
}

// CHECK: m_{{[0-9]+}}[int(0)][int(0)] = globalParams_{{[0-9]+}}.v_{{[0-9]+}}[int(0)];
// CHECK: m_{{[0-9]+}}[int(1)][int(1)] = globalParams_{{[0-9]+}}.v_{{[0-9]+}}[int(1)];
// CHECK-NOT: _m00
