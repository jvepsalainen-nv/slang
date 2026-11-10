//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#nonuniformresourceindex
//META: purpose=`NonUniformResourceIndex(i)` is a no-op at the value level: the operand and result share the same type, so the surrounding indexing expression sees an integer of the same width.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the divergence marker is a value-level identity: it
// wraps an index and hands back a value of the same type, which is why
// the wrapped expression can be used directly as a buffer subscript.
// This file uses the signed-index shape so it differs from the unsigned
// form in `non-uniform-resource-index.slang`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int i = (int)tid.x;
    int nu = NonUniformResourceIndex(i);
    rwbuf[nu] = nu;
}

// IR-LABEL: func %main
// IR: nonUniformResourceIndex(%{{.*}})
