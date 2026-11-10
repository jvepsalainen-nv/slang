//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30311 (type-cannot-conform-to-both-value-and-pointer-diff-interfaces) - type cannot conform to both value and pointer differentiation interfaces
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30311
//META: catalog_name=type-cannot-conform-to-both-value-and-pointer-diff-interfaces
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A type cannot conform to both IDifferentiable and IDifferentiablePtrType.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S : IDifferentiable, IDifferentiablePtrType {}

void main() {}

//CHECK: 30311
