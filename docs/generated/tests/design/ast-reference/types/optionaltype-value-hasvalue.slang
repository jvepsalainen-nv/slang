//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#nodes
//META: purpose=An OptionalType<T> carries a value type and holds either a wrapped T or no value; `.hasValue` and `.value` expose the two states.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both states of the optional type: one Optional<int> is
// initialised with a wrapped value and one with no value. CHECK asserts
// hasValue plus the unwrapped payload for the first, and hasValue false
// for the second, so a type that collapsed the two states would fail.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    Optional<int> a = 42;
    Optional<int> b = none;
    // CHECK: a.hasValue=1
    printf("a.hasValue=%d\n", a.hasValue ? 1 : 0);
    // CHECK: a.value=42
    printf("a.value=%d\n", a.value);
    // CHECK: b.hasValue=0
    printf("b.hasValue=%d\n", b.hasValue ? 1 : 0);
}
