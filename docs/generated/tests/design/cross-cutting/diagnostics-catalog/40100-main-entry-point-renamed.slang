//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E40100 (main-entry-point-renamed) - entry point '~oldName' has been renamed to '~newName'
//META: intent=negative
//META: pipeline_stage=emit
//META: catalog_code=40100
//META: catalog_name=main-entry-point-renamed
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Metal reserves the name `main`, so an entry point spelled `main` cannot keep
// that name in the emitted source. The compiler renames it and warns; the CHECK
// pins the renamed-entry-point warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target metal -entry main -stage compute
RWStructuredBuffer<int> o;

[numthreads(1,1,1)]
void main() { o[0] = 1; }

//CHECK: E40100
