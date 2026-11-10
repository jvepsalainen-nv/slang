//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31132 (derivative-member-attribute-can-only-be-used-on-members) -- DerivativeMember on non-member
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31132
//META: catalog_name=derivative-member-attribute-can-only-be-used-on-members
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[DerivativeMember(x)]
float f;


//CHECK: E31132
