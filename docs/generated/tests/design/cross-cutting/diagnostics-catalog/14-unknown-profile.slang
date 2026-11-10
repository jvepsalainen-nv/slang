//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00014 (unknown-profile) - unknown profile '~profile'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=14
//META: catalog_name=unknown-profile
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-profile` only accepts profile names the driver knows. Passing a made-up name
// makes option parsing fail; the CHECK pins the unknown-profile code so the
// rejection cannot silently degrade into a default profile.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-profile bogusprofile
[numthreads(1,1,1)]
void main() {}

//CHECK: E00014
