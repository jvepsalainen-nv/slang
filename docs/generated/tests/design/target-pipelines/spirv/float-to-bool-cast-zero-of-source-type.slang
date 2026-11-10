//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#float-to-bool-casts
//META: purpose=A float-to-bool cast compares against a zero constant of the source floating-point type, emitting OpFUnordNotEqual against an OpConstant %float 0.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the float-to-bool cast path builds its zero comparand from the
// *source* type: a float source must be compared against a float zero, not an
// integer zero wearing a float type. The float comes from a buffer load so the
// comparison survives to emit; CHECK asserts an OpConstant %float 0 exists and
// that the cast emits a float-typed not-equal comparison producing %bool.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;
StructuredBuffer<float> inBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float f = inBuf[tid.x];
    bool b = bool(f);
    outBuf[tid.x] = b ? 1 : 0;
}

// CHECK-DAG: %float_0 = OpConstant %float 0
// CHECK-DAG: OpFUnordNotEqual %bool %{{[a-zA-Z_0-9]+}} %float_0
