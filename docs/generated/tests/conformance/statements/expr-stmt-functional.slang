//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#expression-statement
//META: purpose=An expression statement (expression followed by semicolon) is a valid statement form.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an expression statement (function call followed by `;`) executes.
// Also verifies that an assignment expression followed by `;` updates the variable.
//TEST:INTERPRET(filecheck=CHECK):

int computeValue(int x) { return x * 2; }

void main()
{
    int result = 0;
    // Assignment expression statement
    result = computeValue(5);
    // CHECK: 10
    printf("%d\n", result);
}
