//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00019 (unknown-source-language) - unknown source language '~language'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=19
//META: catalog_name=unknown-source-language
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-lang` selects the source language for the following inputs. A name outside
// the known set is rejected during option parsing; the CHECK pins that code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-lang bogus
[numthreads(1,1,1)]
void main() {}

//CHECK: E00019
