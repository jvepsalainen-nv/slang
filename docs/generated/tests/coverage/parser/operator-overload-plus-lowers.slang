//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#parser
//META: purpose=Verifies a user `operator+` declaration parses and a `a + b` use of it evaluates to the overload's result.
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: the operator-name parser accepts `+` as an overloadable
// operator, producing a function named `operator+`. This exercises the
// success side of the same branch that operator-decl-invalid-symbol pins on
// the failure side. Two V values are summed via the user overload; CHECK
// asserts the result component is 5 (2+3), which is only reachable if the
// declaration parsed and bound as the `+` operator.

//TEST:INTERPRET(filecheck=CHECK):

struct V { int x; }
V operator+(V a, V b) { V r; r.x = a.x + b.x; return r; }

void main()
{
    V a; a.x = 2;
    V b; b.x = 3;
    V c = a + b;
//CHECK: 5
    printf("%d\n", c.x);
}
