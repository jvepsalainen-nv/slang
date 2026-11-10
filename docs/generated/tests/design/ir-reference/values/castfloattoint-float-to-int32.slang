//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `float -> int` truncation lowers to a single `castFloatToInt(%fa)` with `Int` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Isolates the float-to-int direction (the existing smoke test
// bundled it with int-to-float). The doc notes the truncation
// semantics live on this opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(fa);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%fa)
