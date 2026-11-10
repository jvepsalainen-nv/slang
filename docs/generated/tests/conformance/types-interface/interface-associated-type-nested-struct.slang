//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An associated type requirement may be satisfied by a nested struct declaration with the same name inside the conforming struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an associatedtype requirement is satisfied by a nested struct
// with the same name. The test declares ContainerWithNested : IHasNestedType,
// whose inner Item struct stands in for the associated type; CHECK confirms
// the struct fields are set and returned correctly.

//TEST:INTERPRET(filecheck=CHECK):

interface IHasNestedType
{
    associatedtype Item;
    Item makeItem();
}

struct ContainerWithNested : IHasNestedType
{
    struct Item
    {
        int code;
    }

    Item makeItem()
    {
        Item it;
        it.code = 7;
        return it;
    }
}

void main()
{
    ContainerWithNested c;
    ContainerWithNested.Item item = c.makeItem();
    //CHECK: code=7
    printf("code=%d\n", item.code);
}
