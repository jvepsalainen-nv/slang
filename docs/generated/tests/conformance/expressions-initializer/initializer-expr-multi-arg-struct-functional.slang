//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-expressions
//META: purpose=An initializer expression initializes an instance of the specified type using the given arguments — verified on a user-defined struct type.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// C2: "An initializer expression initialized an instance of the specified type
// using the given arguments." Verified on a user struct to ensure argument
// values flow into the resulting instance correctly (not just vector builtins).
// Use function parameters to defeat the constant folder.

//TEST:INTERPRET(filecheck=CHECK):

struct Point { int x; int y; };

int passInt(int v) { return v; }

void main()
{
    Point p = Point(passInt(5), passInt(10));
    //CHECK: 5 10
    printf("%d %d\n", p.x, p.y);
}
