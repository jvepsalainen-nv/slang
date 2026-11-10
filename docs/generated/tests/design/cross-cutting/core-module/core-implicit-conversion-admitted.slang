//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#what-the-core-module-provides
//META: purpose=The core module's __implicit_conversion declarations admit int-to-float argument conversion while an exact-match overload still wins over a converting one.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the implicit-conversion rules the core module declares are
// both present and ranked. `widen` accepts only float, so calling it
// with an int proves a conversion is admitted at all; `pick` offers
// int and float overloads, so calling it with an int proves the
// zero-cost exact match outranks the conversion. The CHECK pins
// pick=1 (the int overload) together with widen's converted result.

//TEST:INTERPRET(filecheck=CHECK):

float widen(float x) { return x * 2.0; }
int pick(int) { return 1; }
int pick(float) { return 2; }

void main()
{
    int i = 3;
    // CHECK: widened=6.0 pick=1
    printf("widened=%.1f pick=%d\n", widen(i), pick(i));
}
