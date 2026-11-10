//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#identifier-expressions
//META: purpose=An identifier expression looks up the name in the environment and yields the value of the matching declaration.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An identifier expression (bare name) resolves to the declared variable in scope.
// Tests that reading a local and a module-scope constant via bare identifiers works.
//TEST:INTERPRET(filecheck=CHECK):

static const int answer = 42;

int getAnswer()
{
    // 'answer' is an identifier expression resolving to the module-scope constant.
    return answer;
}

void main()
{
    int x = 7;
    // 'x' is an identifier expression resolving to the local variable.
    int y = x;
    int z = getAnswer();
    //CHECK: 7
    //CHECK: 42
    printf("%d\n", y);
    printf("%d\n", z);
}
