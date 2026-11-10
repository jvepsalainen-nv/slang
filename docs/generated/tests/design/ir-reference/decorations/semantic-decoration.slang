//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#interpolation-and-shader-io
//META: purpose=A parameter declared with an HLSL system-value semantic produces a semantic decoration with (name, index) operands; the index is -1 when none is written.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two-operand shape of `semantic`: a string name and an
// integer index. The entry-point parameter carries `SV_DispatchThreadID`
// with no index, and the CHECK pins `-1` as the second operand, which is
// how "no explicit index" is encoded.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [semantic("SV_DispatchThreadID", -1 : Int)]
