//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=The checker finds the witness that a type satisfies the interface a generic constraint requires, so a generic bounded on that interface accepts every conformer.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies witness lookup for a constraint. `describe` can only call `code()`
// because the constraint supplies a witness that the bound type implements
// `INamed`; two unrelated conformers are passed through the same generic so a
// single accidentally-shared witness would collapse the results. CHECK asserts
// both distinct values.

//TEST:INTERPRET(filecheck=CHECK):

interface INamed
{
    int code();
}

struct Alpha : INamed
{
    int code() { return 11; }
}

struct Beta : INamed
{
    int code() { return 22; }
}

int describe<T : INamed>(T v)
{
    return v.code();
}

void main()
{
    Alpha a;
    Beta b;
    // CHECK: a=11 b=22
    printf("a=%d b=%d\n", describe(a), describe(b));
}
