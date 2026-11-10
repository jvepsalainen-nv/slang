//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that an empty InitializerListExpr `{}` zero-initializes the aggregate — every field reads back as 0.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for InitializerListExpr.args: the empty list.
// `Rect r = {};` must zero-initialize every field.

//TEST:INTERPRET(filecheck=CHECK):

struct Rect { int a; int b; int c; }

void main()
{
    Rect r = {};
    // CHECK: a=0 b=0 c=0
    printf("a=%d b=%d c=%d\n", r.a, r.b, r.c);
}
