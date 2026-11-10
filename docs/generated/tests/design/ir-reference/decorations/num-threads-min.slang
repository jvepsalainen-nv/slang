//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=Boundary - the smallest legal numthreads(1,1,1) lowers to numThreads(1 : Int, 1 : Int, 1 : Int) with all three operands at 1.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower edge of the workgroup size. All three operands are the
// minimum legal value at once, which is the shape most likely to be
// special-cased or elided; the CHECK asserts the decoration is emitted with
// three explicit `1` operands.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [numThreads(1 : Int, 1 : Int, 1 : Int)]
// CHECK: func %main
