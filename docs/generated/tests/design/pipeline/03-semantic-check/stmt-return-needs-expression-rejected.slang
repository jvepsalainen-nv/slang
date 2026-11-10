//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Statement checking validates `return` against the function's return type, so a bare `return` in an `int` function is rejected with E30006.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "return-type validation" concern. The enclosing function is
// declared to return `int`, so a valueless `return` cannot satisfy it; CHECK
// pins E30006 on the return statement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int f()
{
    return;
//CHECK: E30006
}

void main()
{
    f();
}
