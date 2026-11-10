//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#concepts
//META: purpose=The declaration being checked is excluded from its own lookup, so a typedef that reuses the name it is defined from resolves that name to the outer declaration.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the self-exclusion the doc illustrates with `typedef Foo
// Foo;`. Inside namespace N the typedef and its right-hand side share
// the spelling Foo; without excluding the decl under check, the alias
// would resolve to itself. CHECK asserts 21 read back through a field
// of the file-scope struct, which is only reachable if Foo inside N
// denotes that struct.

//TEST:INTERPRET(filecheck=CHECK):

struct Foo { int v; }

namespace N
{
    typedef Foo Foo;

    int use() { Foo f; f.v = 21; return f.v; }
}

void main()
{
    // CHECK: r=21
    printf("r=%d\n", N::use());
}
