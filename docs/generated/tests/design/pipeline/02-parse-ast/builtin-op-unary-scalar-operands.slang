//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#the-major-node-families
//META: purpose=Builtin unary operators (arithmetic negate, logical not, bitwise not) over builtin scalar operands are rewritten by the checker and evaluate correctly.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the checker's builtin-operator rewrite covers the unary
// operator class. Each unary form (`-`, `!`, `~`) is applied to a
// runtime value from a function call; CHECK asserts the negated,
// logically-inverted, and bit-inverted results.

//TEST:INTERPRET(filecheck=CHECK):

int pass(int v)
{
    return v;
}

void main()
{
    int x = pass(7);
    bool t = x > 0;
    uint u = uint(pass(0));
    // CHECK: neg=-7 not=0 bnot=4294967295
    printf("neg=%d not=%d bnot=%u\n", -x, int(!t), ~u);
}
