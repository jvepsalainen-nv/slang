//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=A conformance `WhereTerm` may list several supertypes after one colon: `Type ':' Type (',' Type)*`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the comma-continued supertype list inside a single
// conformance term: `where T : IA, IB` constrains one parameter to
// both interfaces with one `where` keyword. The body calls a method
// from each interface on the same value.

//TEST:INTERPRET(filecheck=CHECK):

interface IA { int a(); }
interface IB { int b(); }

struct S : IA, IB
{
    int a() { return 40; }
    int b() { return 2; }
}

int both<T>(T t) where T : IA, IB
{
    return t.a() + t.b();
}

void main()
{
    S s;
    // CHECK: r=42
    printf("r=%d\n", both(s));
}
