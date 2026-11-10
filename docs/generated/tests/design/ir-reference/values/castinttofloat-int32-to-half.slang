//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `int -> half` lowers directly to `castIntToFloat(%a)` with `Half` result — no intermediate `float` step at IR level.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Tests that int-to-half does not synthesize an intermediate
// int-to-float-then-float-to-half pair; the doc places it under
// one `castIntToFloat` opcode keyed by the result float type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<half> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = half(a);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%a)
