//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#inputs-and-outputs
//META: purpose=The checker attaches a Type to every Expr, so a mixed int/float sum is typed float and selects the float overload at the enclosing call.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "types attached" half of the output contract by making the
// attached type observable. Two `probe` overloads differ only in parameter
// type, so which one runs is decided purely by the `Type*` the checker
// hung on the `i + f` expression. CHECK asserts the float overload ran,
// which is only possible if the sum was typed float rather than int.

//TEST:INTERPRET(filecheck=CHECK):

int probe(float v)
{
    return 1;
}

int probe(int v)
{
    return 2;
}

void main()
{
    int i = 3;
    float f = 0.5f;
    // CHECK: k=1
    printf("k=%d\n", probe(i + f));
}
