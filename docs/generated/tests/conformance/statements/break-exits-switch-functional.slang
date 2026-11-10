//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#break-statement
//META: purpose=break transfers control to after the end of the immediately enclosing switch statement.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that break in a switch body exits the switch and continues after it.
// After the switch, the variable is checked to confirm control transferred correctly.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    switch (5)
    {
    case 5:
        x = 1;
        break;
        x = 99; // unreachable
    default:
        x = -1;
        break;
    }
    // Only case 5 body ran; break exited; unreachable code not reached
    // CHECK: 1
    printf("%d\n", x);
}
