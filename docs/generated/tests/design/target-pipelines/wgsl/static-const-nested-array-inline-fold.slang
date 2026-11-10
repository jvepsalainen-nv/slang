//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#wgslsourceemitter-module-scope-array-constants
//META: purpose=A nested module-scope static const array folds its inner array constituents inline into the outer const initializer rather than emitting separately named inner declarations
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the shared emitter's aggregate-constituent folding rule
// (isInnerGlobalAggregate): the inner rows of a 2D `static const` array are
// inlined into the outer module-scope `const` initializer instead of being
// emitted as separate named declarations. The runtime row/column indices
// keep the array from folding away; CHECK pins the nested array<array<i32
// type and an inner `(array<i32` constructor appearing inline inside the
// outer initializer on the same declaration.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

static const int kGrid[2][3] = { { 1, 2, 3 }, { 4, 5, 6 } };

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = kGrid[tid.x & 1][tid.x % 3];
}

// CHECK: const kGrid_{{[0-9]+}} : array<array<i32
// CHECK-SAME: = array
// CHECK-SAME: ( array<i32
