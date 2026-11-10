//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#generic-parameters-accessors-and-synthesized-members
//META: purpose=A synthesized differential type propagates the parent member's visibility; a `public` function may name the auto-synthesized `Differential` of a `public` struct in its signature.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the auto-synthesized `Primal.Differential` carries the parent
// struct's `public` visibility rather than an unrelated default. A
// `public` function whose signature names `Primal.Differential` only
// passes checkVisibility (no use-of-less-visible-type rejection) if the
// synthesized type's visibility propagated up to `public`. CHECK asserts
// the program checked, lowered, and ran through that signature.

//TEST:INTERPRET(filecheck=CHECK):

public struct Primal : IDifferentiable
{
    public float x;
}

public Primal.Differential passThrough(Primal.Differential d)
{
    return d;
}

void main()
{
    Primal.Differential d = Primal.dzero();
    d = passThrough(d);
    // CHECK: ok=1
    printf("ok=%d\n", 1);
}
