//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30105 (expand-term-captures-no-type-packs) - 'expand' captures no type packs
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30105
//META: catalog_name=expand-term-captures-no-type-packs
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `expand` builds a pack expression from a term that mentions at least one type
// pack. A term that captures none has nothing to expand over, which the CHECK
// pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = expand 1; }

//CHECK: E30105
