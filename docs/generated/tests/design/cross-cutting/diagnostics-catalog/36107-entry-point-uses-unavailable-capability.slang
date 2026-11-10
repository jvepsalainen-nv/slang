//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E36107 (entry-point-uses-unavailable-capability) - unavailable features in entry point
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=36107
//META: catalog_name=entry-point-uses-unavailable-capability
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An entry point may only use features its target supports. `printf` is outside
// the WGSL compute capability set, so the capability check rejects the entry
// point before emit and the CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target wgsl -entry main -stage compute
[numthreads(1,1,1)]
void main() { printf("x"); }

//CHECK: E36107
