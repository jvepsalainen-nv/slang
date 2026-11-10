//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#namedexpressiontype
//META: purpose=A NamedExpressionType prints under its alias name but is canonicalized to the aliased type for type-mismatch diagnostics, so a mismatch involving a typealias names the aliased type, not the alias.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the canonicalize-first half of the NamedExpressionType note: given
// `typealias Celsius = float`, a mismatch diagnostic says `float`. The CHECK
// pins both the diagnostic code and the aliased spelling in the message; the
// alias name `Celsius` never appears in it.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1): -target hlsl -stage compute -entry main

typealias Celsius = float;
struct S { int v; }

[numthreads(1, 1, 1)]
void main()
{
    Celsius c = 1.0;
    S s = c;
}
// CHECK: E30019
// CHECK: expected an expression of type 'S', got 'float'
