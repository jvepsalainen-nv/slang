//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=A null pointer (`nullptr`) is a valid pointer value that compares equal to `nullptr` and not equal to a non-null pointer.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `nullptr` is a valid pointer value and that null/non-null comparison
// produces the right boolean. Compares a null pointer and a real pointer each
// against nullptr; CHECK asserts the results are 1 and 0 respectively.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 5;
    int* nul = nullptr;
    int* non = &x;
    int is_null   = (nul == nullptr) ? 1 : 0;  // 1
    int is_notnull = (non == nullptr) ? 1 : 0;  // 0
    //CHECK: 1 0
    printf("%d %d\n", is_null, is_notnull);
}
