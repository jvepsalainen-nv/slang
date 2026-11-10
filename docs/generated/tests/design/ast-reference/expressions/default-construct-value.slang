//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A `T()` zero-argument invocation default-constructs a value of T, observable as zero-initialized fields of a plain struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// DefaultConstructExpr is documented as "synthesized expression for a
// default-constructed value". Its user-spellable surface is `T()`
// with no arguments. For a plain struct of ints, all fields default
// to zero.

//TEST:INTERPRET(filecheck=CHECK):

struct Vec { int x; int y; int z; }

void main()
{
    Vec v = Vec();
    // CHECK: x=0 y=0 z=0
    printf("x=%d y=%d z=%d\n", v.x, v.y, v.z);
}
