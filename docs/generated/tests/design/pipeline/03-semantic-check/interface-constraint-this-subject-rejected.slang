//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A bare-`This` subject on an interface `__constraint` is rejected during checking because it would express inheritance rather than a checked predicate.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out the checker applies to `__constraint` subjects.
// Writing `This` as the subject would silently mean "this interface inherits
// IBar", which the language spells with an inheritance clause instead, so the
// constraint form has to be refused. CHECK pins E30427 on the `This` subject.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IBar
{
    int bar();
}

interface IThis
{
    __constraint This : IBar;
//CHECK: E30427
}

void main()
{
}
