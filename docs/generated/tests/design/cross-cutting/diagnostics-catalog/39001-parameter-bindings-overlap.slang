//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39001 (parameter-bindings-overlap) - explicit binding overlap
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39001
//META: catalog_name=parameter-bindings-overlap
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two parameters with identical `register(t0)` bindings trigger
// E39001.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

Texture2D a : register(t0);
Texture2D b : register(t0);

//CHECK: E39001