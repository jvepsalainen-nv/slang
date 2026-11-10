//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#name-lookup-and-declref
//META: purpose=A DeclRef records the substitution that binds a generic parameter, so two instantiations of one generic function behave as different concrete types.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that name resolution yields a decl *plus* a substitution rather
// than a bare decl. `describe` is one declaration; the two call sites differ
// only in the type bound to `T`, and the interface method each dispatches to
// is chosen by that binding. CHECK asserts both instantiations returned their
// own value, which requires the substitution to be part of the reference.

//TEST:INTERPRET(filecheck=CHECK):

interface INamed
{
    int code();
}

struct Red : INamed
{
    int code() { return 1; }
}

struct Blue : INamed
{
    int code() { return 2; }
}

int describe<T : INamed>(T v)
{
    return v.code();
}

void main()
{
    Red r;
    Blue b;
    // CHECK: a=1 b=2
    printf("a=%d b=%d\n", describe(r), describe(b));
}
