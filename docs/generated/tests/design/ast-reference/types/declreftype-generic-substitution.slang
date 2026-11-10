//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#declreftype
//META: purpose=A type defined by reference to a declaration also carries whatever generic substitutions the decl-ref encodes, so two instantiations of one generic struct behave as distinct types with substituted field types.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the decl-ref carries generic arguments alongside the
// declaration: Box<int> and Box<float> name the same struct but
// substitute different field types. Each stores and reads back a value
// at its own substituted type; CHECK asserts both, so a shared
// (unsubstituted) field type would be visible as a wrong readback.

//TEST:INTERPRET(filecheck=CHECK):

struct Box<T> { T value; }

void main()
{
    Box<int> bi;
    bi.value = 7;
    Box<float> bf;
    bf.value = 2.5f;
    // CHECK: bi=7
    printf("bi=%d\n", bi.value);
    // CHECK: bf=2
    printf("bf=%d\n", int(bf.value));
}
