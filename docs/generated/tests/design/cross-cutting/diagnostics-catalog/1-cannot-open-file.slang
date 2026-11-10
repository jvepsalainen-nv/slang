//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E1 (cannot-open-file) from a minimum-reproduction input.
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=1
//META: catalog_name=cannot-open-file
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Minimum reproduction for diagnostic E1.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
import nonexistent_module_xyz_pqrs;
void main() {}

//CHECK: E00001
