//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#comments
//META: purpose=A line comment extends up to but does not include the next line break; the following line is parsed normally.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a line comment ends at the newline, leaving the next
// line's tokens available to the parser. Two variables declared on
// lines with trailing `//` comments are summed; CHECK on `sum=3`
// proves neither declaration was consumed by the comment.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 1; // comment that runs to end of this line
    int b = 2;     // and another
    int sum = a + b;
    //CHECK: sum=3
    printf("sum=%d\n", sum);
}
