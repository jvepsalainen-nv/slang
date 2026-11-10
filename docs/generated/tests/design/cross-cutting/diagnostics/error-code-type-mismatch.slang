//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A checker-range code (E30019) is rendered for a type-mismatch condition.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `type-mismatch` (30019) to its rendered code. The diag has
// a typed-name interpolation via ~expectedType:Type and
// ~actualType:QualType in the span message.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int4 v = int4(int(tid.x));
    bool b = v;
}

// CHECK: E30019
// CHECK: type mismatch
// CHECK: expected an expression of type 'bool'
