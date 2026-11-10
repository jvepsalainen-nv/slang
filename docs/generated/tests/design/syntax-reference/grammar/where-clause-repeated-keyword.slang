//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#generics-and-where-clauses
//META: purpose=`WhereClause ::= ('where' WhereTerm)+` — each `where` keyword introduces exactly one term; several constraints repeat the keyword.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the repeated-keyword shape of a multi-constraint where
// clause: `where T : IA where U : IB` states two terms with two
// `where` keywords. The generic body uses a method from each
// constraint, so both terms must have been recorded.

//TEST:INTERPRET(filecheck=CHECK):

interface IA { int a(); }
interface IB { int b(); }

struct SA : IA { int a() { return 30; } }
struct SB : IB { int b() { return 12; } }

int combine<T, U>(T t, U u) where T : IA where U : IB
{
    return t.a() + u.b();
}

void main()
{
    SA sa;
    SB sb;
    // CHECK: r=42
    printf("r=%d\n", combine(sa, sb));
}
