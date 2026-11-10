//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#intval-family
//META: purpose=A sizeof of a type is a compile-time integer value, usable in a constant initializer, and is strictly positive for a non-empty type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `sizeof` yields an integer the checker can evaluate
// before codegen. The result initializes a `static const int`, which
// only type-checks if the value is compile-time known; CHECK asserts
// the sign test prints 1. The exact byte count is target-dependent, so
// only positivity is asserted.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    static const int SZ = int(sizeof(int));
    // CHECK: positive=1
    printf("positive=%d\n", SZ > 0 ? 1 : 0);
}
