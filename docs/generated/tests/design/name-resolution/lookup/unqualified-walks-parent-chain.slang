//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=The unqualified-lookup outer loop walks the scope parent chain outward to the module root, so a name inside a nested block resolves through the enclosing function scope and then the file scope.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that unqualified lookup keeps stepping to the parent scope
// until it finds the name. `p` is two scopes out (block -> function
// parameter scope) and `K` is three scopes out (block -> function ->
// file). CHECK asserts the sum 7 + 1000, which is only produced when
// both names resolved through the outward walk.

//TEST:INTERPRET(filecheck=CHECK):

static const int K = 1000;

int adder(int p)
{
    {
        int sum = p + K;
        return sum;
    }
}

void main()
{
    // CHECK: r=1007
    printf("r=%d\n", adder(7));
}
