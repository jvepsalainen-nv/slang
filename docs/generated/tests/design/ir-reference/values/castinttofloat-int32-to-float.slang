//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: signed `int -> float` lowers to a single `castIntToFloat(%a)` with `Float` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Most common int-to-float surface (signed 32-bit). The existing
// smoke test bundles this with float-to-int; this isolates the
// int-to-float direction with a clean single anchor.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(a);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%a)
