//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38047 (mesh-shader-missing-output-topology) - mesh shader missing [outputtopology] attribute
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38047
//META: catalog_name=mesh-shader-missing-output-topology
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A mesh shader entry point missing `[outputtopology(...)]`
// triggers E38047.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -O0

[shader("mesh")]
[numthreads(1,1,1)]
void main() {}

//CHECK: E38047
