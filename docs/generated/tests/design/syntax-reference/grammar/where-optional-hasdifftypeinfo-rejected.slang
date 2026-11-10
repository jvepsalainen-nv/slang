//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`optional` before a `__hasDiffTypeInfo(...)` where-term is diagnosed by the parser with E30315.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the one where-term that does not tolerate a leading `optional`.
// CHECK asserts E30315, which only the parser's optional-prefix guard emits.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

void f<T>(T t) where optional __hasDiffTypeInfo(T) {}

// CHECK: E30315
