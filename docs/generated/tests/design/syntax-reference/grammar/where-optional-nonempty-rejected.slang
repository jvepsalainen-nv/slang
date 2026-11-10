//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`optional nonempty(Pack)` parses but the checker rejects it with E30415.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `optional` is consumed on `nonempty(...)` but then rejected as
// meaningless by the checker; CHECK asserts E30415.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f<each T>(expand each T t) where optional nonempty(T) {}

// CHECK: E30415
