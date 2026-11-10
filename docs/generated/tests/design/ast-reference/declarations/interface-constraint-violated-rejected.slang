//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#generictypeconstraintdecl-as-an-interface-requirement
//META: purpose=A type whose associated type breaks an interface's `__constraint` requirement fails to conform and is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative half of the `__constraint` requirement. The struct
// satisfies every ordinary member requirement but sets its associated type to
// `int` instead of itself, so the `DataType == This` requirement fails; the
// CHECKs pin the conformance error at the inheritance clause.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

interface IBase { associatedtype DataType; int val(); }

interface ISelf : IBase { __constraint DataType == This; }

struct S : ISelf
//CHECK:   ^^^^^ type argument doesn't conform to interface
//CHECK:   ^^^^^ type argument 'S' does not conform to the required interface 'ISelf'
{
    typealias DataType = int;
    int val() { return 1; }
}

void main() {}
