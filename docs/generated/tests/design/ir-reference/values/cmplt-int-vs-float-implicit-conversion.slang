//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: comparing `int < float` triggers an implicit `castIntToFloat` on the int operand before `cmpLT`; verifies the documented conversion opcode bridges the type mismatch.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The Conversions table is the only place that names how mixed
// int/float operands meet a common type. The implicit conversion
// surfaces a `castIntToFloat` before the comparison.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int ia;
uniform float fa;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(ia < fa, 1, 0);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%ia)
// IR: cmpLT(%{{[0-9]+}}, %fa)
