//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A non-square `float2x4` matrix lowers with IR type `Mat(Float, 2 : Int, 4 : Int, 0 : Enum(Int))`; the row/column operands appear in source order.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: matrix-shape axis — rectangular (rows != columns).
// Verifies that the IR's Mat(...) row-then-column operand order
// matches the source's R x C declaration order.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float2x4 m;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = m[0][0];
}

// CHECK: [nameHint("m")]
// CHECK: let {{.*}}m{{.*}}: Mat(Float, 2 : Int, 4 : Int, 0 : Enum(Int)){{.*}}= global_param
