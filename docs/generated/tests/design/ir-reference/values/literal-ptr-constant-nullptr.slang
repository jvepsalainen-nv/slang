//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#literal-payload-encoding
//META: purpose=A `nullptr` literal becomes a `ptr_constant` whose inline payload the IR dump renders as the bare token `<ptr>` at each use site.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pointer-literal case of the inline-payload spelling
// table. Like the other constants, a `ptr_constant` is folded into its
// uses instead of getting a definition line, and the printer has a
// dedicated case for it that emits `<ptr>` rather than a numeric value
// with a type clause. Comparing a null pointer against `nullptr` puts
// two of them in operand position at once, so CHECK can assert the
// exact rendered form `cmpEQ(<ptr>, <ptr>)` inside `main`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Ptr<int> p = nullptr;
    buf[0] = (p == nullptr) ? 1 : 0;
}

// IR-LABEL: func %main
// IR: : Bool	= cmpEQ(<ptr>, <ptr>)
