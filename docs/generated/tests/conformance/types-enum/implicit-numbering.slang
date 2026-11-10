//META: generated=true
//META: doc_ref=docs/language-reference/types-enum.md#description
//META: purpose=Implicit numbering: first enumerator is 0; each subsequent unspecified is previous+1.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

enum Color { Red, Green, Blue, Alpha }

void main()
{
    //CHECK: 0 1 2 3
    printf("%d %d %d %d\n",
           int(Color.Red), int(Color.Green),
           int(Color.Blue), int(Color.Alpha));
}
