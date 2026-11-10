//META: generated=true
//META: purpose=Using the comma operator inside an expression emits a may-be-unintended warning (E41024) but still compiles.
//META: intent=characterization
//META: covers=source/slang/slang-check-expr.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the InfixExpr comma-operator branch in checkExpr: a top-level
// comma sequence in a parenthesized expression triggers the
// CommaOperatorUsedInExpression warning (E41024); CHECK pins the warning text.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry test -stage fragment

int test(int a, int b) { return (a, b); }
//CHECK:                          ^ comma operator used in expression
//CHECK:                          ^ comma operator used in expression (may be unintended)

// CHECK: E41024
