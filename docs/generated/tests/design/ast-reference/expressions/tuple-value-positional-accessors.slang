//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A tuple value exposes its members through the positional `._0` / `._1` accessors.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a tuple value built by `makeTuple` exposes its components
// through the positional `._i` accessors. Two components of different types
// are stored and read back separately, so a mis-ordered or mistyped component
// fails a CHECK.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    Tuple<int, float> t = makeTuple(7, 1.5f);
    // CHECK: a=7
    printf("a=%d\n", t._0);
    // CHECK: b=1
    printf("b=%d\n", int(t._1));
}
