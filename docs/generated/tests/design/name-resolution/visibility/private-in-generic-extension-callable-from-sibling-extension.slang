//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#where-visibility-is-filtered
//META: purpose=A `private` member declared in a generic `extension` is reachable from an extension on a concrete instantiation of the same type, because the predicate resolves and compares the two extensions' target types.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the generic arm of the extension target-type comparison. The
// private `twice` is declared in `extension<T> G<T>`; the caller sits in
// `extension G<int>`, a different instantiation. Access is permitted only
// because the candidate's extension target type is specialized and matched
// against the requesting scope's container type, rather than the two
// extensions being compared by identity. The CHECK asserts the private
// member's result reached the caller.

//TEST:INTERPRET(filecheck=CHECK):

struct G<T : IArithmetic>
{
    T value;
    __init(T v) { value = v; }
}

extension<T : IArithmetic> G<T>
{
    private T twice() { return value + value; }
}

extension G<int>
{
    int viaOtherInstantiation() { return twice(); }
}

void main()
{
    G<int> g = G<int>(21);
    // CHECK: g=42
    printf("g=%d\n", g.viaOtherInstantiation());
}
