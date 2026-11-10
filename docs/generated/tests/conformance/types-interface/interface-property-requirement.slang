//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may declare a property requirement with get/set accessors without bodies; the conforming struct provides compatible get and set implementations.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a property requirement declared with bodyless `get; set;`
// in an interface is satisfied by a conforming struct supplying accessor
// implementations. PropWithAccessors stores the value via `_val`; CHECK
// asserts the round-trip set/get returns 55.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasProp
{
    property val : int
    {
        get;
        set;
    }
}

struct PropWithAccessors : IHasProp
{
    int _val;
    property val : int
    {
        get { return _val; }
        set(int v) { _val = v; }
    }
}

void main()
{
    PropWithAccessors obj;
    obj.val = 55;
    //CHECK: val=55
    printf("val=%d\n", obj.val);
}
