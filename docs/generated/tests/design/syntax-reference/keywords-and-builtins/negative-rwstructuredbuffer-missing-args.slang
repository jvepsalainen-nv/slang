//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#core-module-syntax-declarations
//META: purpose=Negative: `RWStructuredBuffer` is supplied by `hlsl.meta.slang` as a generic type and must be instantiated with a template argument; using the bare name rejects with `E30408`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the lower edge of the documented `RWStructuredBuffer<T>`
// template-arg requirement. The bare name without `<T>` triggers a
// type-checker error.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

RWStructuredBuffer outBuf;
// CHECK-DAG: error
// CHECK-DAG: RWStructuredBuffer
// CHECK-DAG: E30408

void main() {}
