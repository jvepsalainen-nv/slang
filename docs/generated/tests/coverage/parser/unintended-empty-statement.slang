//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#error-recovery
//META: purpose=Verifies a lone `;` as the body of an `if` emits the W20101 unintended-empty-statement warning (compile still succeeds).
//META: intent=characterization
//META: covers=source/slang/slang-parser.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: an empty statement (`;`) directly as a controlled
// statement is a common typo; the statement parser warns but recovers and
// compiles. CHECK pins the E20101 warning code and the observed message.
// This is a warning, so the compile succeeds.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

[numthreads(1, 1, 1)]
void main()
{
    if (true);
//CHECK: E20101
//CHECK: potentially unintended empty statement at this location; use {} instead.
}
