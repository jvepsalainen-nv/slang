//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#enumeration-types
//META: purpose=An explicit tag value in the middle of an enum sets that case's value; subsequent cases without an explicit value continue from there.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an explicit tag value mid-enum resets the counter and subsequent cases increment.
// `Red` gets 0 by default, `Green` is pinned to 3, and `Blue` must be 4;
// CHECK lines assert all three printed values match.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green = 3, Blue }

void main()
{
    // CHECK: 0
    // CHECK: 3
    // CHECK: 4
    printf("%d\n", int(Color.Red));
    printf("%d\n", int(Color.Green));
    printf("%d\n", int(Color.Blue));
}
