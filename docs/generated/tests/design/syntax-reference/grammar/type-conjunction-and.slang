//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#types
//META: purpose=`CoreType` accepts the infix conjunction form `CoreType '&' CoreType`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `&` in type position parses as the conjunction type
// rather than a bitwise operator or a reference marker. The constraint
// `T : IA & IB` is used as the bound of a generic parameter, and the
// body calls a method from each conjunct; both calls only resolve if
// the single constraint carried both interfaces, so the combined value
// 34 (a()==3, b()==4) is the evidence.

//TEST:INTERPRET(filecheck=CHECK):

interface IA { int a(); }
interface IB { int b(); }

struct S : IA, IB
{
    int a() { return 3; }
    int b() { return 4; }
}

int both<T : IA & IB>(T v) { return v.a() * 10 + v.b(); }

void main()
{
    S s;
    // CHECK: r=34
    printf("r=%d\n", both<S>(s));
}
