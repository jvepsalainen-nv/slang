//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Preprocessor warnings take ids from the conventional 15xxx subsystem range (E15205).
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that preprocessor-stage warnings take ids from the conventional
// 15xxx subsystem range. An unset macro is used in an `#if` condition; the
// caret-anchored CHECK pins code 15205 and the message naming the macro.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#if UNSET_MACRO
/*CHECK:
    ^^^^^^^^^^^ E15205
    ^^^^^^^^^^^ undefined identifier 'UNSET_MACRO' in preprocessor expression will evaluate to zero
*/
#endif

void main() {}
