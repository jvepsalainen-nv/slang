//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#generic-parameters-accessors-and-synthesized-members
//META: purpose=A synthesized requirement witness takes Min(parent visibility, requirement visibility); an internal struct can satisfy an explicitly-public interface requirement without a higher-than-parent violation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the requirement-satisfaction synthesizer caps a synthesized
// member's visibility at Min(parent, requirement). The requirement is
// explicitly `public` while the conforming struct is `internal`; the
// property witness synthesized from the plain field must be capped at
// `internal`, so the program passes checkVisibility (no
// higher-than-parent rejection) and the generic read through the
// interface succeeds. CHECK asserts the value flows through the
// synthesized accessor.

//TEST:INTERPRET(filecheck=CHECK):

public interface IHasValue
{
    public property value : int { get; }
}

internal struct Wrapped : IHasValue
{
    internal int value;
    internal __init(int v) { value = v; }
}

internal int readThrough<T : IHasValue>(T t)
{
    return t.value;
}

void main()
{
    // CHECK: value=42
    printf("value=%d\n", readThrough(Wrapped(42)));
}
