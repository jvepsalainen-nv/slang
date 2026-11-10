//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=The `::` surface form is a distinct static-member spelling: `Limits::kMax` reads a static member through the type without an instance.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `::` member-access surface form, which the parser maps
// straight to a static member access (unlike `.`, which starts as a
// value member access). Reading a `static const int` via `Limits::kMax`
// must yield the declared constant; CHECK asserts the value, which is
// only reachable if the `::` spelling resolves the static member.

//TEST:INTERPRET(filecheck=CHECK):

struct Limits
{
    static const int kMax = 4321;
}

void main()
{
    int v = Limits::kMax;
    // CHECK: v=4321
    printf("v=%d\n", v);
}
