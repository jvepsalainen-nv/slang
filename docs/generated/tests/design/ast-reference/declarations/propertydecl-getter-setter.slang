//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#accessordecl-family
//META: purpose=A PropertyDecl holds GetterDecl/SetterDecl children; reading and writing the property fires the respective accessor.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an explicit `get`/`set` pair on a property is what runs on
// read and write. The setter deliberately doubles the incoming value, so the
// CHECK's expected number is only produced when the write went through the
// setter body and the read through the getter body.

//TEST:INTERPRET(filecheck=CHECK):

struct Box
{
    int _v;
    property int value
    {
        get { return _v; }
        set { _v = newValue * 2; }
    }
}

void main()
{
    Box b;
    b.value = 7;
    //CHECK: 14
    printf("%d\n", b.value);
}
