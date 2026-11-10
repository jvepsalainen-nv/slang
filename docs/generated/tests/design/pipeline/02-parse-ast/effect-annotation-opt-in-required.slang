//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#angle-bracket-annotations
//META: purpose=The declarator-level annotation skip is opt-in, so without `-enable-effect-annotations` the same `< ... >` clause is read as a generic argument list and its `;` is an unexpected token.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the declarator-level skip really is gated rather than always
// on. This is the identical declaration the opt-in test compiles cleanly, run
// without the flag: the `<` then has only one available reading — a generic
// argument list — and the parser stops at the first `;`, reporting it as an
// unexpected token where a `>` was expected. That the complaint is about the
// separator rather than about the annotation syntax as a whole is what shows
// the clause was never recognised as an annotation at all.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

Texture2D tex <string uiName = "Tex"; int uiOrder = 3;>;
//CHECK:                            ^ error E20001
//CHECK:                            ^ unexpected ';', expected '>'

RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void main()
{
    outputBuffer[0] = 0.0;
}
