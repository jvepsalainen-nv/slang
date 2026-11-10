//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ModernParamDecl marked `inout` is mutable and copies the callee's change back to the caller.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the escape hatch from the modern parameter's default immutability:
// with `inout` the name-first parameter can be assigned and the caller sees
// the new value. The CHECK asserts the caller-side variable after the call.

//TEST:INTERPRET(filecheck=CHECK):

func bump(inout x: int)
{
    x = x + 5;
}

void main()
{
    int a = 1;
    bump(a);
    //CHECK: 6
    printf("%d\n", a);
}
