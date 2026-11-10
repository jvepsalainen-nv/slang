//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Below language version 2026 a comma inside parentheses is still the comma operator rather than a tuple construction, so the parenthesized pair evaluates to its right-hand operand.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower side of the tuple language-version gate. Without the 2026
// standard selected, `(10, 20)` is not a tuple at all: the comma is the comma
// operator, so the whole parenthesized expression has type `int` and value 20,
// and it assigns to an `int` without complaint. The CHECK reads that value
// back. Its counterpart tuple-expr-2026-makes-parens-a-tuple.slang compiles
// the same text with `-std 2026` and shows the type becoming
// `Tuple<int, int>`.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = (10, 20);
    printf("x=%d\n", x);
}

//CHECK: x=20
