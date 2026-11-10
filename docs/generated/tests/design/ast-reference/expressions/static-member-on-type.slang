//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=Member access with `.` on a type-valued base (`Limits.kMax`) is reinterpreted during checking to reach the static member without an instance.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `.` member access whose base names a type (not a
// value) still reaches the type's static member: the parser starts it
// as a plain member access, and checking reinterprets it once the base
// resolves to a type. CHECK asserts the static constant's value read
// through `Limits.kMax` without an instance.

//TEST:INTERPRET(filecheck=CHECK):

struct Limits
{
    static const int kMax = 1234;
}

void main()
{
    int v = Limits.kMax;
    // CHECK: v=1234
    printf("v=%d\n", v);
}
