//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#container-level-cap
//META: purpose=The higher-than-parent cap searches for the nearest enclosing aggregate starting at the decl itself, so a nested `public` aggregate inside an `internal` aggregate is compared against itself and accepted.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out that makes the cap bite only on non-aggregate
// members. `Inner` is `public` inside an `internal` `Outer`, which is the
// same shape that E30601 rejects for a `public` method; because the search
// for the nearest enclosing `AggTypeDeclBase` starts at `Inner` itself,
// `Inner` is compared against `Inner` and no violation is reported. The
// CHECK asserts the program checked and ran, returning the nested value.

//TEST:INTERPRET(filecheck=CHECK):

internal struct Outer
{
    public struct Inner { int x; }

    Inner make(int v) { Inner i; i.x = v; return i; }
}

void main()
{
    Outer o;
    Outer.Inner i = o.make(9);
    // CHECK: x=9
    printf("x=%d\n", i.x);
}
