//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#the-major-node-families
//META: purpose=At parse time both function calls and type constructions take the unified form `A(B)` — the `## AST data model` note explicitly says expressions and types share the Expr representation in a freshly-parsed AST.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `int(7)` is a type construction; `identity(7)` is a function call.
// Both reach the parser as the same Expr shape (an InvokeExpr whose
// callee is an identifier). The semantic checker later disambiguates;
// the parser does not.

//TEST:INTERPRET(filecheck=CHECK):

int identity(int v) { return v; }

void main()
{
    int x = int(7);
    int y = identity(7);
    // CHECK: x=7 y=7
    printf("x=%d y=%d\n", x, y);
}
