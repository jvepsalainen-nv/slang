//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A PrefixExpr `-x` is a unary prefix operator that negates an integer value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// PrefixExpr is documented as the AST kind for unary prefix operators
// (`-a`, `!x`). Applying `-` to a positive int must yield its
// negation; applying `-` twice returns the original value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 7;
    int negx = -x;
    int negnegx = -(-x);
    // CHECK: neg=-7
    printf("neg=%d\n", negx);
    // CHECK: negneg=7
    printf("negneg=%d\n", negnegx);
}
