//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-list-expression
//META: purpose=An initializer list expression (zero or more comma-separated expressions enclosed in {}) used as the initial-value of a variable declaration initializes each field in order.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// C4: "An initializer list expression comprises zero or more expressions,
// separated by commas, enclosed in {}: { 1, "hello", 2.0f }"
// Verified by initializing a struct and checking field values are assigned
// in declaration order.

//TEST:INTERPRET(filecheck=CHECK):

struct Color { int r; int g; int b; };

int passInt(int v) { return v; }

void main()
{
    Color c = { passInt(255), passInt(128), passInt(0) };
    //CHECK: 255 128 0
    printf("%d %d %d\n", c.r, c.g, c.b);
}
