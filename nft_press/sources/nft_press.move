module nft_press::nft_press {

    use sui::url::{Self, Url}; // Connect to url housing image
    use sui::tx_context::{sender, TxContext}; // For sending NFT
    use std::string::{utf8, String}; // For naming and description of NFT
    use sui::transfer; // For transfer of NFT to wallet
    use sui::object::{Self, UID}; // For creating NFT
    use sui::package; // For publishing NFT
    use sui::display; // For displaying NFT image

    // NFT takes three parameters: name, description, and image_url
    struct NFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
    }

    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name: utf8(name),
            description: utf8(description),
            image_url: url::new_unsafe_from_bytes(url)
        };

        transfer::transfer(nft, sender);
    }

    // For displaying NFT image
    struct NFT_PRESS has drop {}

    fun init(otw: NFT_PRESS, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{description}"),
            utf8(b"{image_url}"),
        ];

        // Claim the publisher
        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<NFT>(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        // Publish the NFT
        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

}
