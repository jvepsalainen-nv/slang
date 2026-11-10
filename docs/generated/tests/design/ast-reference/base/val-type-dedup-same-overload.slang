//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#val-nodebase
//META: purpose=Vals are deduplicated by the ASTBuilder, so two textually separate spellings of the same type denote one value and select the same overload at every use.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that types are hash-consed values rather than per-site
// objects. Two separately-written `vector<int,3>` declarations are
// passed to an overload set that distinguishes `int`,
// `vector<int,3>` and `vector<float,3>`. CHECK asserts both calls land
// on the same overload; distinct-but-equal type values would let the
// second call diverge or fail to match.

//TEST:INTERPRET(filecheck=CHECK):

int kind(int v)             { return 1; }
int kind(vector<int,3> v)   { return 3; }
int kind(vector<float,3> v) { return 4; }

void main()
{
    vector<int,3> a = vector<int,3>(1, 2, 3);
    vector<int,3> b = vector<int,3>(4, 5, 6);
    //CHECK: a=3
    printf("a=%d\n", kind(a));
    //CHECK: b=3
    printf("b=%d\n", kind(b));
}
