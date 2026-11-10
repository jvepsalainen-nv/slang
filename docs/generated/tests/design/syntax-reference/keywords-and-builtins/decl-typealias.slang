//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`typealias Name = T;` is a decl keyword binding `Name` to type `T`; the alias resolves to its underlying type for overload resolution.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `typealias MyInt = int;` then call a `kind(int)` overload through
// the alias. The overload that matches confirms `MyInt` resolved to
// `int`.

//TEST:INTERPRET(filecheck=CHECK):

typealias MyInt = int;

int kind(int v) { return 1; }
int kind(uint v) { return 2; }

void main()
{
    MyInt x = 42;
    // CHECK: kind=1
    printf("kind=%d\n", kind(x));
}
