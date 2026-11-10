//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=An [earlydepthstencil] attribute lowers to a bare earlyDepthStencil decoration with no operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `earlyDepthStencil` row's operand shape: the decoration is
// nullary, so the dump prints `[earlyDepthStencil]` with no parentheses.
// The attribute is written on a compute entry point because the decoration
// is attached from the modifier during lowering independently of the stage
// the entry point is compiled for, which keeps the observation on a shader
// that needs no rasterizer plumbing.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
[earlydepthstencil]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [earlyDepthStencil]
