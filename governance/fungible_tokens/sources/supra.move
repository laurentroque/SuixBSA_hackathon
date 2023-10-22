module fungible_tokens::supra {
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // Name matches the module name, but in UPPERCASE
    struct SUPRA has drop {}

    // Module initializer is called once on module publish.
    // A treasury cap is sent to the publisher, who then controls minting and burning.
    fun init(witness: SUPRA, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 9, b"SUP", b"SUPRA", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }

    // Manager can mint new SUPRA tokens
    public entry fun mint(
        treasury: &mut coin::TreasuryCap<SUPRA>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }

    // Manager can burn SUPRA tokens
    public entry fun burn(treasury: &mut coin::TreasuryCap<SUPRA>, coin: coin::Coin<SUPRA>) {
        coin::burn(treasury, coin);
    }
}
