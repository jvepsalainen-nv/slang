//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30901 (subscript-must-have-return-type) -- __subscript declaration must have a return type specified after '->'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30901
//META: catalog_name=subscript-must-have-return-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S {
    __subscript(int i) { get { return 1; } }
}


//CHECK: E30901
