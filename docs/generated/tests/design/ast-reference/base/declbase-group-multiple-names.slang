//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#declbase-modifiablesyntaxnode
//META: purpose=A DeclBase can represent a group of declarations, so one piece of syntax that declares several names produces several independently usable declarations.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a single declaration statement naming three variables
// yields three distinct declarations, each with its own initializer.
// CHECK asserts the individual values and their sum; if the grouped
// syntax collapsed to one declaration, the later names would not
// resolve and the sum could not be computed.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 1, b = 2, c = 3;
    //CHECK: a=1 b=2 c=3
    printf("a=%d b=%d c=%d\n", a, b, c);
    //CHECK: sum=6
    printf("sum=%d\n", a + b + c);
}
