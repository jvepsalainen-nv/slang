//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=Inheriting types may override interface default-implementation member functions using the `override` modifier; the overriding implementation is called instead of the default.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `override` modifier causes a struct's method to replace
// the interface default. DefaultUser inherits compute() as base()+100=105;
// OverrideUser replaces it with base()*3=15. CHECK asserts both values,
// confirming the override takes precedence for OverrideUser only.

//TEST:INTERPRET(filecheck=CHECK):

interface IComputable
{
    int base();
    int compute() { return base() + 100; }
}

struct DefaultUser : IComputable
{
    int base() { return 5; }
}

struct OverrideUser : IComputable
{
    int base() { return 5; }
    override int compute() { return base() * 3; }
}

void main()
{
    DefaultUser du;
    OverrideUser ou;
    //CHECK: default=105 overridden=15
    printf("default=%d overridden=%d\n", du.compute(), ou.compute());
}
