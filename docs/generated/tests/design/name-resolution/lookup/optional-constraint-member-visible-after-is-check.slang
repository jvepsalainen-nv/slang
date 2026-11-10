//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#breadcrumbs
//META: purpose=A member reached through an optional conformance survives the post-lookup filter once the surrounding code has checked the constraint with an is statement.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive half of the optional-constraint filter that
// inspects the witness carried on each navigation step. The generic
// declares `optional T : IPrintable`, so the witness on the path to
// `code()` is only usable inside the `is` check; the call is written
// there. CHECK asserts 55, the conformer's implementation, proving the
// item was kept rather than filtered out.

//TEST:INTERPRET(filecheck=CHECK):

interface IPrintable { int code(); }

int tryIt<T>(T v) where optional T : IPrintable
{
    if (T is IPrintable)
    {
        return v.code();
    }
    return -1;
}

struct P : IPrintable { int code() { return 55; } }

void main()
{
    P p;
    // CHECK: r=55
    printf("r=%d\n", tryIt(p));
}
