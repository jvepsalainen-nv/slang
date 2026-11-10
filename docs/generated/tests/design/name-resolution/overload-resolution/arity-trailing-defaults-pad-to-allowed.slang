//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=TryCheckOverloadCandidateArity accepts a call with fewer arguments than parameters when trailing defaults pad the count up to allowed.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "trailing defaults can pad up to allowed" half of the arity
// step, at its lower edge: `pad` has one required and two defaulted
// parameters, and the call supplies exactly the required count. CHECK asserts
// the digits contributed by the two defaults are present, which proves the
// candidate survived the arity step and the defaults were filled in.

//TEST:INTERPRET(filecheck=CHECK):

int pad(int a, int b = 5, int c = 7) { return a * 100 + b * 10 + c; }

void main()
{
    int v = pad(1);
    // CHECK: v=157
    printf("v=%d\n", v);
}
