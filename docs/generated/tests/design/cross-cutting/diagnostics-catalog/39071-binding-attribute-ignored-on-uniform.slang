//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39071 (binding-attribute-ignored-on-uniform) - binding attribute ignored
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39071
//META: catalog_name=binding-attribute-ignored-on-uniform
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A binding attribute on a global uniform (not inside a constant
// buffer) is ignored and triggers E39071.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage compute -entry main

[[vk::binding(1,0)]]
uniform float v;

[numthreads(1,1,1)]
void main() {}

//CHECK: E39071