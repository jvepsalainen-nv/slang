//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#generics
//META: purpose=Implicit specialization infers generic arguments from argument types at the call site; no explicit angle-bracket arguments are needed.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that generic arguments are inferred from call-site argument types without explicit `<>`.
// Calling `myIdentityGeneric(77)` with no angle brackets must bind T=int;
// the printed 77 (asserted below) proves implicit specialization fired.

//TEST:INTERPRET(filecheck=CHECK):

T myIdentityGeneric<T>(T val) { return val; }

void main()
{
    // Implicit specialization to int from argument types (no explicit <int>)
    int r = myIdentityGeneric(77);
    // CHECK: 77
    printf("%d\n", r);
}
