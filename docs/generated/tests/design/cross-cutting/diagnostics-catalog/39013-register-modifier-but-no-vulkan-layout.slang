//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E39013 (register-modifier-but-no-vulkan-layout) - D3D register without Vulkan binding
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=39013
//META: catalog_name=register-modifier-but-no-vulkan-layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A combined Sampler2D using `register(...)` for D3D but without
// `[[vk::binding(...)]]` triggers E39013.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage compute -entry main

Sampler2D<float4> tex : register(t0);

[numthreads(1,1,1)]
void main() {}

//CHECK: E39013