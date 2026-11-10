//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15401 (macro-not-defined) - undefined macro
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15401
//META: catalog_name=macro-not-defined
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#undef` on a name that was never defined is harmless but warned about. The
// CHECK pins the undefined-macro warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#undef NOT_DEFINED_XYZ
void main() {}

//CHECK: E15401
