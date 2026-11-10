//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30200 (redeclaration) - conflicting declaration
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30200
//META: catalog_name=redeclaration
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two declarations of the same name in the same scope conflict unless they are
// overloads. Two variables differing only in type are not overloads, so the
// CHECK pins the redeclaration error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
int gDup;
float gDup;
void main() {}

//CHECK: E30200
