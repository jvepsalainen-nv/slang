//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=The attribute that makes a method's implicit `this` mutable is spelled [__ref] with two leading underscores; a bare [ref] is an unknown attribute and leaves `this` immutable.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says `[mutating]` and `[__ref]` matter to the checker's `this`
// computation (the effective this-parameter information of a
// `FunctionDeclBase`), not to lookup. `RefAttribute`'s only surface is
// `attribute_syntax [__ref] : RefAttribute;` in the core module, so the
// two-underscore spelling is the one that makes `this` writable. `Mutable` below
// carries no annotation, and exhaustive mode is what turns that silence into
// an assertion: assigning to a member from inside a `[__ref]` method is legal
// precisely because `this` became mutable. The bare `[ref]` spelling is not
// the attribute at all, so its method keeps an immutable `this` and the same
// assignment fails.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

struct Mutable
{
    int v;
    [__ref] void bump() { v = v + 1; }
}

struct NotAnAttribute
{
    int v;
    [ref] void bump() { v = v + 1; }
/*CHECK:
     ^^^ warning E31000
     ^^^ unknown attribute 'ref'
                        ^ note E30049
                          ^ error E30011
                          ^ left of '=' is not an l-value
*/
}

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    Mutable m;
    m.v = 1;
    m.bump();
    gOut[0] = m.v;
}
