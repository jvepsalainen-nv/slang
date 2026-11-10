//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#nonuniformresourceindex
//META: purpose=`NonUniformResourceIndex(i)` surfaces as `nonUniformResourceIndex(%i)` — a no-op at the value level whose operand and result share the same type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the divergence marker survives lowering as its own
// opcode instead of being folded into the index expression. The index
// is thread-derived so it stays an SSA value, and the CHECK finds the
// wrapper in `func %main` — evidence that the information is carried to
// the backend rather than discarded during checking.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint nu = NonUniformResourceIndex(tid.x);
    rwbuf[nu] = tid.x;
}

// IR-LABEL: func %main
// IR: nonUniformResourceIndex(%{{.*}})
