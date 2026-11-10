//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E32001 (anonymous-scoped-enum) - anonymous scoped enum is not allowed
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=32001
//META: catalog_name=anonymous-scoped-enum
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A scoped enum's members are reached through its name, so an anonymous scoped
// enum would be unusable. The CHECK pins the anonymous-scoped-enum error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute
enum class { A, B };
[numthreads(1,1,1)]
void main() { }

//CHECK: E32001
