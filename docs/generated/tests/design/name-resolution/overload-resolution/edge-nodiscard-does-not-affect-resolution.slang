//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#edge-cases-and-failure-modes
//META: purpose=[NoDiscard] is checked only after a call has been resolved, so it contributes no conversion cost and does not make a candidate more or less viable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the attribute is invisible to ranking. The int overload carries
// [NoDiscard] and still wins on cost alone for an int argument, and the call's
// result is consumed so the attribute's own check stays quiet. CHECK asserts
// the int overload's tag.

//TEST:INTERPRET(filecheck=CHECK):

[NoDiscard] int pick(int x) { return 1; }
int pick(float x)           { return 2; }

void main()
{
    int a = 3;
    int tag = pick(a);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
