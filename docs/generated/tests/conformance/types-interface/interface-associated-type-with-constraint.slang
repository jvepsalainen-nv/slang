//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An associated type may be constrained to conform to another interface (`associatedtype T : IOther`); the provided type must itself conform to that interface.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a constrained associatedtype (`Elem : IReq`) requires the
// provided concrete type to itself conform to IReq. Owner supplies ElemImpl
// which implements reqValue(); CHECK asserts the call returns 77, proving
// the constraint was satisfied and the method is reachable through the association.

//TEST:INTERPRET(filecheck=CHECK):

interface IReq
{
    int reqValue();
}

interface IOwner
{
    associatedtype Elem : IReq;
    Elem getElem();
}

struct ElemImpl : IReq
{
    int val;
    int reqValue() { return val; }
}

struct Owner : IOwner
{
    typealias Elem = ElemImpl;

    ElemImpl getElem()
    {
        ElemImpl e;
        e.val = 77;
        return e;
    }
}

void main()
{
    Owner o;
    ElemImpl e = o.getElem();
    //CHECK: reqValue=77
    printf("reqValue=%d\n", e.reqValue());
}
