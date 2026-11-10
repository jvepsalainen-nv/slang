//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#swizzle-swizzleset-swizzledstore
//META: purpose=Boundary: full-length swizzle `.xyzw` on a `float4` lowers to `swizzle(%v, 0, 1, 2, 3)` — the M=N edge of the swizzle width.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The upper-equal edge: M = N = 4. The IR carries the four literal
// indices verbatim on the operand list of the `swizzle` opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float4 v;
uniform RWStructuredBuffer<float4> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.xyzw;
}

// IR-LABEL: func %main
// IR: swizzle(%v, 0 : Int, 1 : Int, 2 : Int, 3 : Int)
