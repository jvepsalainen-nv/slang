//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=A comparison other than `==` after `countof(Pack)` is consumed and reported as E30436.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `countof(T) < 3` is diagnosed as requiring `==`; CHECK asserts E30436.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f<each T>(expand each T t) where countof(T) < 3 {}

// CHECK: E30436
