//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#subscripts
//META: purpose=A `__subscript` declaration with a `get` accessor enables `[]` syntax; reading via `[]` invokes the getter.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `__subscript` with a `get` accessor enables `[]` read syntax.
// `v[0]` and `v[1]` call the getter which branches on the index; CHECK lines assert
// 5 and 9, confirming both accesses invoked the getter with the correct index.

//TEST:INTERPRET(filecheck=CHECK):

struct MyVec
{
    float x, y;
    __subscript(int index) -> float
    {
        get { return index == 0 ? x : y; }
    }
}

void main()
{
    MyVec v;
    v.x = 5.0;
    v.y = 9.0;
    // CHECK: 5
    // CHECK: 9
    printf("%g\n%g\n", v[0], v[1]);
}
