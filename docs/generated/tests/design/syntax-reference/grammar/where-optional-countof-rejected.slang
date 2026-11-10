//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`optional countof(Pack) == N` parses but the checker rejects it with E30434.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `optional` is consumed on a `countof` pack-count term but then
// rejected by the checker; CHECK asserts E30434.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f<each T>(expand each T t) where optional countof(T) == 2 {}

// CHECK: E30434
