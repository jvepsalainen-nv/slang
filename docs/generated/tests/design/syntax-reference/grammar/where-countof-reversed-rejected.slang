//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=The reversed `N == countof(Pack)` spelling is diagnosed with E30437 asking for `countof` on the left.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `3 == countof(T)` is recognized only to emit the targeted
// diagnostic; CHECK asserts E30437.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f<each T>(expand each T t) where 3 == countof(T) {}

// CHECK: E30437
