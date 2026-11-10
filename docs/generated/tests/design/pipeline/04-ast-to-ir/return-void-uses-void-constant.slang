//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#mapping-ast-constructs-to-ir
//META: purpose=A `return` from a void-returning function lowers to `return_val(void_constant)` — the doc's "ReturnStmt → IRReturn terminator" claim, void variant.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc maps `ReturnStmt` to `IRReturn`. For a void-returning
// function the operand is `void_constant`, a distinguished constant
// inst. Observable for the entry-point `void main(...)` directly.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 1;
}

// CHECK-LABEL: func %main
// CHECK: return_val(void_constant)
