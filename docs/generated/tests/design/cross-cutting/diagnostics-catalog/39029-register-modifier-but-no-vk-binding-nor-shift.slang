//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39029 (register-modifier-but-no-vk-binding-nor-shift) - D3D register without Vulkan binding or shift
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39029
//META: catalog_name=register-modifier-but-no-vk-binding-nor-shift
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Compiling a parameter that has a `register(...)` semantic but
// no `[[vk::binding(...)]]` (and no `-fvk-...-shift`) for SPIR-V
// triggers E39029.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage compute -entry main

Texture2D<float> tex : register(t0);

[numthreads(1,1,1)]
void main() {}

//CHECK: E39029