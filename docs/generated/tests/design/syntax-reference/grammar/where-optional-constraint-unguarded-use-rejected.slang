//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=Using a member provided by an `optional` constraint without an `is` guard is diagnosed with E30403.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies an optional conformance constraint must be tested with `is` before
// use: calling `t.g()` unguarded is rejected, CHECK asserts E30403.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

interface IFoo { int g(); }

int f<T>(T t) where optional T : IFoo
{
    return t.g();
}

// CHECK: E30403
