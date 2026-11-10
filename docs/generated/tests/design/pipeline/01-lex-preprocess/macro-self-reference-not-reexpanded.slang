//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#macro-expansion
//META: purpose=A macro that names itself in its own body is not re-expanded: the inner occurrence reaches the parser as a plain identifier, with no diagnostic from the preprocessor.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion is self-suppressing: while SELF is being expanded it is on the
// busy list, so the SELF inside its own body stays an identifier. Here that
// identifier is a local `SELF` declared in `main`, so the program
// compiles and the value shows the body expanded exactly once.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int SELF = 10;
#define SELF (SELF + 1)
    // CHECK: self=11
    printf("self=%d\n", SELF);
}
