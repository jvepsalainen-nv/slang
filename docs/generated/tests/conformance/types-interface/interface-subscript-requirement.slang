//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may declare a subscript operator requirement without a body; the conforming struct provides compatible get and set implementations.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `__subscript` requirement declared with bodyless `get; set;`
// is satisfied by a conforming struct providing accessor implementations.
// FixedArray writes via fa[0]/fa[1] and reads back; CHECK asserts elem0=10
// and elem1=20, confirming both accessors route correctly.

//TEST:INTERPRET(filecheck=CHECK):

interface IIndexable
{
    __subscript(uint i) -> int { get; set; }
}

struct FixedArray : IIndexable
{
    int data[4];

    __subscript(uint i) -> int
    {
        get { return data[i]; }
        set { data[i] = newValue; }
    }
}

void main()
{
    FixedArray fa;
    fa.data[0] = 0;
    fa.data[1] = 0;
    fa[0] = 10;
    fa[1] = 20;
    //CHECK: elem0=10 elem1=20
    printf("elem0=%d elem1=%d\n", fa[0], fa[1]);
}
