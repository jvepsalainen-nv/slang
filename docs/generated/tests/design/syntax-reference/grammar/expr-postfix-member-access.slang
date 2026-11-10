//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=`PostfixSuffix` accepts `'.' IDENT` member access, binding tighter than arithmetic.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `.member` postfix binds at level 1 (tighter than
// arithmetic). `p.a + p.b` parses as `(p.a) + (p.b)`.

//TEST:INTERPRET(filecheck=CHECK):

struct Pair { int a; int b; }

void main()
{
    Pair p;
    p.a = 10;
    p.b = 32;
    int r = p.a + p.b;
    // CHECK: r=42
    printf("r=%d\n", r);
}
