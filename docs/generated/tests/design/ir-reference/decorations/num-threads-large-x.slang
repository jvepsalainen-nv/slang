//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=Boundary - a large workgroup dimension (1024) on numthreads flows through unchanged into the numThreads decoration's first integer operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the upper end of the workgroup-dimension range is carried
// through as a plain integer operand. 1024 is the largest single dimension
// the common APIs accept; the CHECK pins it exactly, so a narrowing or
// clamping of the operand would fail.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;

[numthreads(1024, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}

// CHECK: [numThreads(1024 : Int, 1 : Int, 1 : Int)]
// CHECK: func %main
