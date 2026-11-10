//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#interlocked-is-a-wrapper-not-an-opcode
//META: purpose=HLSL's `InterlockedAdd(dest, value, original)` is a `[ForceInline]` core-module function, so immediately after AST lowering `func %main` holds a `call`, not an `atomicAdd` opcode.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `Interlocked*` family is a wrapper rather than an
// opcode. The call is made on an element of an `RWStructuredBuffer`, so
// the buffer element pointer and the `out` parameter's `var` are both
// visible; the CHECK matches the `call specialize(...)` that receives
// them and uses `IR-NEXT` to show that the instruction following the
// call is ordinary integer arithmetic — no atomic opcode is produced at
// this stage.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int idx = (int)tid.x;
    int prev;
    InterlockedAdd(rwbuf[idx], idx + 1, prev);
    rwbuf[idx + 1] = prev;
}

// IR-LABEL: func %main
// IR: rwstructuredBufferGetElementPtr(%rwbuf, %idx)
// IR: call specialize({{.*}})({{.*}}%prev)
// IR-NEXT: add(%idx, 1 : Int)
