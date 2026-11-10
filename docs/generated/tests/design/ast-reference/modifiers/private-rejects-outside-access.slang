//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#visibility-modifiers-and-language-version
//META: purpose=A `private` member is not accessible from outside its enclosing type.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `private` narrows visibility to the enclosing type declaration
// rather than being an accepted no-op keyword. The field is read from a free
// function and CHECK pins the visibility error code, which only fires if the
// modifier actually restricted lookup.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S
{
    private int secret;
}

void main()
{
    S s;
    int v = s.secret;
    //CHECK: error
    //CHECK: E30600
}
