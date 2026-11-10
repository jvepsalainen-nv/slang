//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: purpose=The `==` operator lowers to `cmpEQ` and `!=` lowers to `cmpNE`.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `cmpEQ` and `cmpNE` are the equality / inequality comparison
// opcodes in the doc's Comparison table. The cross-cutting bundle
// covers `cmpGT`; this test covers the remaining equality pair.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(a == b, 1, 0);
    buf[1] = select(a != b, 1, 0);
}

// IR-LABEL: func %main
// IR: cmpEQ(%a, %b)
// IR: cmpNE(%a, %b)
