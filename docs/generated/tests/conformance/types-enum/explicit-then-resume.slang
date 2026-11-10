//META: generated=true
//META: doc_ref=docs/language-reference/types-enum.md#description
//META: purpose=Explicit-value-then-resume: after `= V`, subsequent unspecified enumerators continue from V+1.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

enum E { A = 10, B, C, D = 100, E2, F }

void main()
{
    //CHECK: 10 11 12 100 101 102
    printf("%d %d %d %d %d %d\n",
           int(E.A), int(E.B), int(E.C),
           int(E.D), int(E.E2), int(E.F));
}
