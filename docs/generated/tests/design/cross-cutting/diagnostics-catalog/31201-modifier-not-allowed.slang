//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31201 (modifier-not-allowed) -- modifier not allowed
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31201
//META: catalog_name=modifier-not-allowed
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main() {
    nointerpolation int x = 5;
}


//CHECK: E31201
