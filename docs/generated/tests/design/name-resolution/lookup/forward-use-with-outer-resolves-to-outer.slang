//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#block-local-shadowing
//META: purpose=A local is hidden from lookup until its own declaration statement is reached, so a reference earlier in the block binds to a same-named outer decl instead.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that block-local hiding is a lookup filter, not an outright
// error: the inner `q` is skipped at the earlier use site, so the walk
// continues outward and finds the file-scope `q`. CHECK asserts the
// earlier statement saw 1000 while the later print of the same
// spelling sees the local 7, which separates hiding from shadowing.

//TEST:INTERPRET(filecheck=CHECK):

static const int q = 1000;

void main()
{
    int y = q + 1;
    int q = 7;
    // CHECK: y=1001 inner=7
    printf("y=%d inner=%d\n", y, q);
}
