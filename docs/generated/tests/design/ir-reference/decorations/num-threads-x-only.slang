//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=Boundary - numthreads with a single x argument defaults the missing y and z dimensions to 1, surfacing as numThreads(x : Int, 1 : Int, 1 : Int).
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the minimum operand count of `numThreads` is satisfied even
// when the user writes fewer arguments: the front end fills y and z with 1.
// The CHECK pins all three operands, so an omitted-operand lowering that
// left the decoration short would fail here.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(64)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [numThreads(64 : Int, 1 : Int, 1 : Int)]
// CHECK: func %main
