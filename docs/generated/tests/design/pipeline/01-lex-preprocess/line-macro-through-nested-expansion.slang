//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=`__LINE__` referenced through nested macro expansion reports the line of the initiating top-level invocation, not a macro-definition line.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the value reported by the __LINE__ builtin derives
// from the initiating top-level location even when it is reached
// through two levels of macro expansion. The use site is line 22 of
// this file; a value of 20 or 21 would mean the builtin was
// attributed to a macro-definition line instead.

//TEST:INTERPRET(filecheck=CHECK):

#define INNER_LINE __LINE__
#define OUTER_LINE INNER_LINE

void main()
{
    // CHECK: line=22
    printf("line=%d\n", OUTER_LINE);
}
