//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#where-visibility-is-filtered
//META: purpose=In `JustTrying` mode the overload-time visibility check silently drops an inaccessible candidate instead of diagnosing, so a visible overload can win a call that the private one matched better.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the silent-drop half of the overload-time check. From outside the
// struct, `s.compute(3)` matches the `private int compute(int)` overload
// exactly, but that candidate is dropped without a diagnostic; the surviving
// `internal float compute(float)` wins through an implicit conversion. The
// CHECK asserts the float result 6.0 rather than the int overload's 30,
// which is the observable difference between dropping the candidate and
// diagnosing it.

//TEST:INTERPRET(filecheck=CHECK):

struct S
{
    private int compute(int x) { return x * 10; }
    internal float compute(float x) { return x * 2.0; }
}

void main()
{
    S s;
    // CHECK: r=6.000000
    printf("r=%f\n", s.compute(3));
}
