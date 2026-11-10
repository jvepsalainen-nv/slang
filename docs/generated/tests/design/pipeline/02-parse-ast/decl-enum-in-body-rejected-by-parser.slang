//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=A `struct` declaration inside a function body parses, but an `enum` is not routed to the declaration path and is rejected with E30102 "enum is not allowed here."
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the statement parser routes only `struct` (and HLSL `class`) into the
// declaration path inside a function body; `enum` falls to the generic
// rejection (it also leaves unexpected-token follow-ups, which are
// deliberately not annotated, hence non-exhaustive). CHECK pins the E30102 code and the kind-specific wording.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int main()
{
    enum E { A = 3 };
//CHECK: ^ error E30102
//CHECK: ^ enum is not allowed here.
    return 0;
}
