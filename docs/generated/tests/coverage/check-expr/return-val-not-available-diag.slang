//META: generated=true
//META: purpose=Using `__return_val` in a function whose return type is copyable reports that it is not available (E38104).
//META: intent=characterization
//META: covers=source/slang/slang-check-expr.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes visitReturnValExpr's rejection path. `__return_val` names the
// caller-provided storage for the return value, and the checker only gives it a
// type when the enclosing function returns an error type or a non-copyable type.
// Here the enclosing function returns plain `int`, so neither branch applies and
// the expression is diagnosed and typed as an error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry test -stage fragment

int test()
{
    __return_val = 1;
/*CHECK:
    ^^^^^^^^^^^^ E38104
    ^^^^^^^^^^^^ cannot use '__return_val' here. '__return_val' is defined only in functions that return a non-copyable value.
*/
    return 0;
}
