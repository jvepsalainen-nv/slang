//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30065 (new-can-only-be-used-to-initialize-a-class) - `new` can only be used to initialize a class
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30065
//META: catalog_name=new-can-only-be-used-to-initialize-a-class
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `new` is reserved for reference-typed `class` declarations. Applying it to a
// value-typed `struct` is rejected, and the CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
struct S { int a; }
void main() { S s = new S(); }

//CHECK: E30065
