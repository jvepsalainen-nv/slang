//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A defaulted generic parameter that the caller omits is filled in by the constraint solver's fixpoint, so the default type is used.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the complementary path of the same claim: with no explicit
// argument in that position, the parameter's default has to be routed through
// the solver alongside the inferred and witness arguments. CHECK asserts 21,
// which is `Two` for the written argument and the `One` default for the
// omitted one.

//TEST:INTERPRET(filecheck=CHECK):

interface ITag
{
    static int tag();
}

struct One : ITag
{
    static int tag() { return 1; }
}

struct Two : ITag
{
    static int tag() { return 2; }
}

int probe<T : ITag, U : ITag = One>()
{
    return T.tag() * 10 + U.tag();
}

void main()
{
    // CHECK: v=21
    printf("v=%d\n", probe<Two>());
}
