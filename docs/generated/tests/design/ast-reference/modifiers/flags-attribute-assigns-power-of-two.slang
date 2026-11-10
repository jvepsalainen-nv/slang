//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[Flags]` on an enum gives successive cases consecutive power-of-two values instead of consecutive integers.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `[Flags]` changes how implicit enum case values are assigned, which
// is what makes the cases usable as a bit set. `Read` / `Write` / `Exec` have no
// explicit initialisers, and CHECK asserts they are 1, 2, 4 -- a plain enum would
// have numbered them 1, 2, 3.

//TEST:INTERPRET(filecheck=CHECK):

[Flags]
enum Perm
{
    None = 0,
    Read,
    Write,
    Exec,
}

void main()
{
    //CHECK: r=1 w=2 e=4
    printf("r=%d w=%d e=%d\n", int(Perm.Read), int(Perm.Write), int(Perm.Exec));
}
