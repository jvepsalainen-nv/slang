//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#andtype
//META: purpose=An AndType `IA & IB` tracks a conjunction of conformance requirements; a type conforming to both is accepted and both interfaces' methods dispatch in the generic body.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a conjunction constraint admits both interfaces at once
// without a named composite interface being declared. The generic body
// calls one method from each interface and combines them; CHECK asserts
// the combined result, which is unreachable unless both conformances
// were carried by the single constraint.

//TEST:INTERPRET(filecheck=CHECK):

interface IA { int a(); }
interface IB { int b(); }

struct Both : IA, IB
{
    int a() { return 3; }
    int b() { return 4; }
}

int combined<T : IA & IB>(T v) { return v.a() * 10 + v.b(); }

void main()
{
    Both o;
    // CHECK: r=34
    printf("r=%d\n", combined(o));
}
