//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=Assignment `=` (level 14) is right-associative; `a = b = 5` parses as `a = (b = 5)`.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies right-associativity of assignment. `a = b = 5` is parsed as
// `a = (b = 5)` so both variables end up at 5. Left associativity would
// be a parse error (`(a = b) = 5` writes to a non-lvalue).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 0, b = 0;
    a = b = 5;
    // CHECK: a=5,b=5
    printf("a=%d,b=%d\n", a, b);
}
