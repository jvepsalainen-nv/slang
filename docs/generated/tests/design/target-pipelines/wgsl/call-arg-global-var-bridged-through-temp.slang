//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizecall-and-the-ptrfunction-t-address-space-rule
//META: purpose=A module-scope static global passed to an out parameter is bridged through a function-space temporary and copied back
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `GlobalVar` row of legalizeCall's argument table. A module
// scope `static` lives in WGSL's `private` address space, and handing it
// straight to a `ptr<function, T>` parameter is the address-space mismatch
// WGSL rejects. Because the callee's parameter is `out` -- copy-in/out
// semantics -- the pass must emit a local `Var`, pass that, and copy the
// result back. CHECK asserts the callee takes ptr<function, i32>, that the
// call argument is a local temporary rather than the global itself, and
// that the global is assigned after the call.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;
static int gCounter = 0;

void bump(out int v) { v = 5; }

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bump(gCounter);
    outBuf[tid.x] = gCounter;
}

// CHECK: fn bump_{{[0-9]+}}( {{[A-Za-z0-9_]+}} : ptr<function, i32>)
// CHECK: var<private> gCounter_{{[0-9]+}} : i32
// CHECK: bump_{{[0-9]+}}(&(_S{{[0-9]+}}))
// CHECK: gCounter_{{[0-9]+}} = _S{{[0-9]+}}
