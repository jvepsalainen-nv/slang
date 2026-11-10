//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizecall-and-the-ptrfunction-t-address-space-rule
//META: purpose=A pointer to a struct field passed to an out parameter is bridged unconditionally through a function-space temporary
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `anything else` row of legalizeCall's argument table: WGSL
// cannot form a pointer to a sub-part of a composite value, so an argument
// that is a pointer to `s.x` is bridged through a local temporary no matter
// what the callee's parameter mode is. CHECK asserts the call argument is a
// compiler temporary rather than an address of the field, and that the field
// is written back after the call returns.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

struct S { int x; int y; };
RWStructuredBuffer<int> outBuf;

void bump(out int v) { v = 5; }

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    S s;
    s.x = 1;
    s.y = 2;
    bump(s.x);
    outBuf[tid.x] = s.x + s.y;
}

// CHECK: bump_{{[0-9]+}}(&(_S{{[0-9]+}}))
// CHECK: s_{{[0-9]+}}.x_{{[0-9]+}} = _S{{[0-9]+}}
