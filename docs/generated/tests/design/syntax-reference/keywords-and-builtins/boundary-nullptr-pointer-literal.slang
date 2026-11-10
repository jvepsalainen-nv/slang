//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#expression-keywords
//META: purpose=Boundary: `nullptr` is documented in the expression-keywords table as the null pointer literal; it compares equal to itself when stored in a pointer-typed binding.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Covers the `nullptr` expression keyword that was not exercised by
// the smoke tests. A pointer-typed local set to `nullptr` compares
// equal to `nullptr`, returning 1.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int* p = nullptr;
    // CHECK: eq=1
    printf("eq=%d\n", (p == nullptr) ? 1 : 0);
}
