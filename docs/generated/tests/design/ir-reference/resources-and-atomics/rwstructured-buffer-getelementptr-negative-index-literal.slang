//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#rwstructuredbuffergetelementptr
//META: purpose=Writing `rwbuf[-1] = v` (signed-underflow index literal) still surfaces the documented `rwstructuredBufferGetElementPtr(%base, -1 : Int)` opcode shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: literal `-1` on the lvalue path; this hits the
// signed-underflow corner. The doc states no runtime behavior at this
// boundary (see Doc gaps observed in README.md).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> rwbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    rwbuf[-1] = (int)tid.x;
}

// IR-LABEL: func %main
// IR: rwstructuredBufferGetElementPtr(%rwbuf, -1 : Int)
