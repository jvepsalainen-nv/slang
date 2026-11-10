//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E29110 (unknown-target-name) - unknown target name
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=29110
//META: catalog_name=unknown-target-name
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `__target_switch` case labels name compilation targets. A label that matches
// no known target is rejected, and the CHECK pins the unknown-target-name code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv
void main() { __target_switch { case bogus_target_name: break; } }

//CHECK: E29110
