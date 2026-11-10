//META: generated=true
//META: doc_ref=docs/language-reference/types-enum.md#description
//META: purpose=Multiple enumerators may share the same numeric value per the doc's "Multiple enumerators may share the same numeric value."
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

enum E { A = 5, B = 5, C = 5, D = 7 }

void main()
{
    //CHECK: 5 5 5 7
    printf("%d %d %d %d\n",
           int(E.A), int(E.B), int(E.C), int(E.D));
}
