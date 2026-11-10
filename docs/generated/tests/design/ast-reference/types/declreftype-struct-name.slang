//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#declreftype
//META: purpose=A struct name is a type defined by reference to its declaration; a variable declared with that name stores the struct's fields and member access resolves through the declaration.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a user-declared struct name is usable directly as a
// value type and that member lookup follows the referenced declaration.
// Three fields are written then summed; CHECK asserts the sum, which is
// only reachable if each `.x`/`.y`/`.z` resolved through the decl-ref to
// its own member.

//TEST:INTERPRET(filecheck=CHECK):

struct Vec3i { int x; int y; int z; }

void main()
{
    Vec3i v;
    v.x = 11;
    v.y = 22;
    v.z = 33;
    // CHECK: sum=66
    printf("sum=%d\n", v.x + v.y + v.z);
}
