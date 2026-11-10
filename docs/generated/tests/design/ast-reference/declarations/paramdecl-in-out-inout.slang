//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ParamDecl carries a direction; an `inout` parameter propagates the callee's mutation back to the caller while `in` does not.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a function parameter's direction qualifier is part of the
// parameter declaration and governs copy-back. Two calls mutate their
// parameter identically; the CHECK asserts the caller sees the change only
// for the `inout` parameter, which is what distinguishes the two directions.

//TEST:INTERPRET(filecheck=CHECK):

void bumpInOut(inout int x) { x = x + 10; }
void bumpInOnly(in int x)   { x = x + 100; }

void main()
{
    int a = 1;
    bumpInOut(a);
    int b = 1;
    bumpInOnly(b);
    //CHECK: a=11 b=1
    printf("a=%d b=%d\n", a, b);
}
