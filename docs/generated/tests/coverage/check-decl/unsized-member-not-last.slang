//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=Verifies an unsized (runtime-array) struct member that is not the last member is rejected with E30070.
//META: intent=characterization
//META: covers=source/slang/slang-check-decl.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization: a member of unknown compile-time size (`int arr[]`)
// must be the trailing member of its composite. Placing a sized member
// after it drives the unsized-member-placement check. CHECK pins E30070.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct S
{
    int arr[];
//CHECK:^^^ unsized member must be last
//CHECK:^^^ member with unknown size at compile time can only appear as the last member in a composite type.
    int b;
}

[numthreads(1, 1, 1)]
void main() {}
