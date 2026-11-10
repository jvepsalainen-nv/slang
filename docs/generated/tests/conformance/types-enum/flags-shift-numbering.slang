//META: generated=true
//META: doc_ref=docs/language-reference/types-enum.md#description
//META: purpose=`[Flags]` attribute: first enumerator is 1; each subsequent unspecified is previous << 1 (1, 2, 4, 8, ...).
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `[Flags]` assigns auto-values as a power-of-two sequence
// starting at 1. An enum with four unspecified enumerators is cast to int
// and printed; CHECK on `1 2 4 8` proves each auto-value is the previous
// one left-shifted by 1.

//TEST:INTERPRET(filecheck=CHECK):

[Flags]
enum Perm { Read, Write, Execute, Delete }

void main()
{
    //CHECK: 1 2 4 8
    printf("%d %d %d %d\n",
           int(Perm.Read), int(Perm.Write),
           int(Perm.Execute), int(Perm.Delete));
}
