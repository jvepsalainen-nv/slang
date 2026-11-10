//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30821 (tag-type-must-be-listed-first) -- an enum type may only have a single tag type, and that type must be listed first in the list of bases
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30821
//META: catalog_name=tag-type-must-be-listed-first
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

interface I {}
enum E : I, int { A }


//CHECK: E30821
