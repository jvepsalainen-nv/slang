//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30408 (generic-type-needs-args) - generic type '~type:Type' used without argument
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30408
//META: catalog_name=generic-type-needs-args
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A generic type name is not a type until it is applied to arguments. Using
// bare `S` where a type is expected fires the needs-arguments error, which the
// CHECK pins.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
struct S<T> { T v; }
void main() { S s; }

//CHECK: E30408
