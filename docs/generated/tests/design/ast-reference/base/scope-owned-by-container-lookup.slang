//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#root-hierarchy
//META: purpose=A scope is created during parsing and attached to the container declaration that owns it, so a member body can name a sibling member without qualification.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a container declaration owns a lookup scope holding
// its members. Inside `clamped()`, the names `total` and `limit` are
// written bare; resolving them requires the enclosing struct's own
// scope to be on the lookup chain for the method body. CHECK asserts
// the clamped result, which can only be computed if both bare names
// found the sibling fields.

//TEST:INTERPRET(filecheck=CHECK):

struct Accum
{
    int total;
    int limit;

    int clamped() { return total < limit ? total : limit; }
};

void main()
{
    Accum a;
    a.total = 10;
    a.limit = 4;
    //CHECK: clamped=4
    printf("clamped=%d\n", a.clamped());
}
