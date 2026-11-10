//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#punctuation-and-structural-symbols
//META: purpose=The three-character spelling `...` lexes as a single `Ellipsis` token, which the preprocessor consumes as a variadic macro parameter list.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `...` is one token and not `Dot`/`DotDot` fragments. The ellipsis is
// only meaningful to the preprocessor as the whole variadic-parameter spelling,
// so expanding a macro that forwards `__VA_ARGS__` to a three-argument function
// and printing the sum proves the parameter list was recognised.

//TEST:INTERPRET(filecheck=CHECK):

#define FORWARD_ALL(...) addThree(__VA_ARGS__)

int addThree(int a, int b, int c) { return a + b + c; }

void main()
{
    // CHECK: ellipsis=6
    printf("ellipsis=%d\n", FORWARD_ALL(1, 2, 3));
}
