//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-c-wgsl-legalization-lowering-phi-elimination
//META: purpose=asuint() / asfloat() reinterprets emit as WGSL bitcast<T>(...) expressions
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// lowerBitCast feeds the WGSL emitter; reinterpret casts (asuint /
// asfloat) become the WGSL bitcast<T>(...) spelling.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = asuint(1.5f);
}

// CHECK: bitcast<u32>
