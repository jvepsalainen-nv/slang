//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#two-pass-interaction-with-the-parser
//META: purpose=Inside a deferred function body the parser calls back into the checker so `f<1, 2>(3)` is disambiguated as a generic application rather than a chain of comparisons.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `<`-disambiguation callback that the two-pass handoff exists
// for. `tag<1, 2>(3)` is textually ambiguous with `(tag < 1), (2 > 3)`; only a
// parser that can ask the checker whether `tag` names a generic will build a
// generic application here. CHECK asserts the digits of both value arguments
// plus the ordinary argument, which no comparison reading could produce.

//TEST:INTERPRET(filecheck=CHECK):

int tag<let A : int, let B : int>(int d)
{
    return A * 100 + B * 10 + d;
}

void main()
{
    // CHECK: t=123
    printf("t=%d\n", tag<1, 2>(3));
}
