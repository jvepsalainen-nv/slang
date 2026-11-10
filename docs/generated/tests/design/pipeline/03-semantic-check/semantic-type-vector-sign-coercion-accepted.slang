//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=A system-value semantic accepts a declared type of the same shape whose scalar element is in the same category, so `int3` is valid for a `uint3` semantic.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the sign-coercion allowance of the semantic type-compatibility
// rule using the doc's own example: `SV_DispatchThreadID` is a `uint3`
// semantic and the parameter is declared `int3`. Same element count, same
// integer category, so it must be admitted. CHECK asserts the emitted HLSL
// kept the declared signed type on the semantic.

//TEST:SIMPLE(filecheck=CHECK): -target hlsl

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(int3 tid: SV_DispatchThreadID)
{
    outputBuffer[0] = tid.x;
}
// CHECK: int3 {{[A-Za-z0-9_]+}} : SV_DispatchThreadID
