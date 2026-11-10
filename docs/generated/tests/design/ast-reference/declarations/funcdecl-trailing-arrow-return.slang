//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=The modern function spelling `func name(...) -> T` produces the same callable declaration as the C-style spelling.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `func` keyword with a trailing arrow return type declares
// an ordinary function. The function is called like any other and the CHECK
// asserts its result, so a spelling that failed to bind the return type would
// not type-check.

//TEST:INTERPRET(filecheck=CHECK):

func triple(int x) -> int { return x * 3; }

void main()
{
    //CHECK: 33
    printf("%d\n", triple(11));
}
