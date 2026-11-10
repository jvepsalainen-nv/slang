//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#wgslsourceemitter-module-scope-array-constants
//META: purpose=A module-scope static const array indexed by a runtime value emits as a WGSL const declaration with an inline initializer, with no var<private> fallback
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that emitVarKeywordImpl emits a `static const` array as a
// module-scope WGSL `const`, with no var<private> fallback: a WGSL `const`
// array may be indexed by a runtime value and does not count against the
// private-variable size limit. The kernel indexes the array with a
// thread-id-derived value so the access cannot fold; CHECK pins the
// `const` keyword, the array type, and the inline `= array` initializer
// on the module-scope declaration.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

static const int kLut[4] = { 10, 20, 30, 40 };

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = kLut[tid.x & 3];
}

// CHECK: const kLut_{{[0-9]+}} : array<i32
// CHECK-SAME: = array
