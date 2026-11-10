//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=A token copied verbatim from a macro body keeps the macro definition's source location, so a diagnostic about it points into the macro body rather than at the invocation site.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the raw-body-token arm of the source-location rules. The
// macro body names an identifier that is never declared, and the macro
// is invoked far below its definition. Because replaying a body token
// does not build a new source view for the invocation, the resulting
// undefined-identifier diagnostic must be attributed to the `#define`
// line: the caret annotation below sits on the definition, not on the
// use site. The follow-on compilation-ceased diagnostics carry no
// source location of their own, so this file is non-exhaustive.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

#define BODY_REFERENCES_UNDECLARED (undeclared_in_macro_body + 1)
//CHECK:                            ^^^^^^^^^^^^^^^^^^^^^^^^ undefined identifier
// CHECK: E30015

void main()
{
    int x = BODY_REFERENCES_UNDECLARED;
    printf("x=%d\n", x);
}
