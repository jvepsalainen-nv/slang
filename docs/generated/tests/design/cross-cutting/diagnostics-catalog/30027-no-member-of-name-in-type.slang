//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30027 (no-member-of-name-in-type) - member not found
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30027
//META: catalog_name=no-member-of-name-in-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Member lookup is restricted to the members the type declares. Naming a member
// the struct does not have leaves lookup empty, and the CHECK pins the
// member-not-found error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
struct S { int a; }
void main() { S s; int b = s.notAMemberXyz; }

//CHECK: E30027
