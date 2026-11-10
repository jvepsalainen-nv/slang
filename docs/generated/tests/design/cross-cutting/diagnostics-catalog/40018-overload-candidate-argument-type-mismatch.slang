//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E40018 (overload-candidate-argument-type-mismatch) - argument ~argIndex:Int does not match: expected '~expectedType:Type', got '~actualType:Type'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=40018
//META: catalog_name=overload-candidate-argument-type-mismatch
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// When no overload applies, each rejected candidate is explained by a note that
// names the first argument position that does not match. Using a type name where
// a value is expected makes every `operator+` candidate fail on argument 0, and
// the CHECK pins that per-candidate note's code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
struct S { int a; }
void main() { int y = S + 1; }

//CHECK: E40018
