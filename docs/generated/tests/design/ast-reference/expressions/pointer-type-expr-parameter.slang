//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#type-expression-family-pointertypeexpr-functypeexpr-tupletypeexpr-andtypeexpr-modifiedtypeexpr-packbranchtypeexpr
//META: purpose=The pointer type spelling `T*` is accepted in a parameter's type position and resolves to a pointer to `T`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A type spelling like `S*` goes through the same expression parser as a value
// expression and only becomes a type during checking, so the test's job is to
// show the spelling is accepted in a type position and produces the right
// type. A function declares an `S*` parameter and dereferences it; the CHECK
// asserts the callee read the caller's struct through that parameter.

//TEST:INTERPRET(filecheck=CHECK):

struct S { int v; }

int readIt(S* p) { return p->v; }

void main()
{
    S s = { 21 };
    // CHECK: v=21
    printf("v=%d\n", readIt(__getAddress(s)));
}
