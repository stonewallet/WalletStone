
class Keys {
    final String? secretSpendKey;
    final String? secretViewKey;
    final String? publicSpendKey;
    final String? publicViewKey;
    final String?  mnemonicSeed;

    Keys({
         this.secretSpendKey,
         this.secretViewKey,
         this.publicSpendKey,
         this.publicViewKey,
         this. mnemonicSeed,
    });

    factory Keys.fromJson(Map<String, dynamic> json) => Keys(
        secretSpendKey: json["secret_spend_key"],
        secretViewKey: json["secret_view_key"],
        publicSpendKey: json["public_spend_key"],
        publicViewKey: json["public_view_key"],
         mnemonicSeed: json["mnemonic_seed"],
    );

    Map<String, dynamic> toJson() => {
        "secret_spend_key": secretSpendKey,
        "secret_view_key": secretViewKey,
        "public_spend_key": publicSpendKey,
        "public_view_key": publicViewKey,
        "mnemonic_seed": mnemonicSeed,
    };
}
