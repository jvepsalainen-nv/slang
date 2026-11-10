//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#macro-expansion
//META: purpose=Argument tokens replayed for an expanded-parameter reference are themselves macro-expanded, so a macro name passed as an argument expands in the body.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an argument's token range is replayed through a
// macro-expanding stream: the argument to TWICE is itself an
// object-like macro, and both parameter references in the body must
// see its expansion (21), giving 42. If argument tokens were
// replayed without expansion, the identifier BASE would reach the
// parser unresolved and the test would not compile.

//TEST:INTERPRET(filecheck=CHECK):

#define BASE 21
#define TWICE(x) ((x) + (x))

void main()
{
    // CHECK: twice=42
    printf("twice=%d\n", TWICE(BASE));
}
