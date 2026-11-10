//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#tie-breaking-comparator
//META: purpose=getScopeRank prefers the declaration at the shorter scope distance from the call site when both non-generic candidates are otherwise equal.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the scope-distance step, which only runs for non-generic flavors.
// The namespace-local `pick` and the file-scope `pick` accept the call with the
// same cost and specificity; the call sits inside the namespace, so the
// namespace-local one is closer. CHECK asserts its tag.

//TEST:INTERPRET(filecheck=CHECK):

int pick(int x) { return 1; }

namespace Near
{
    int pick(int x) { return 2; }

    int call() { return pick(7); }
}

void main()
{
    int tag = Near::call();
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
