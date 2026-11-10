//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15300 (include-failed) - include file not found
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15300
//META: catalog_name=include-failed
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#include` resolves its path against the search paths. A file present on none
// of them fails the include; the CHECK pins the include-failed error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#include "no-such-file-xyz.h"
void main() {}

//CHECK: E15300
