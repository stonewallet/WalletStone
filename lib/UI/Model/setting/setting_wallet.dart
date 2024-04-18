
class GetWallet {
    final int id;
    final String mnemonic;
    final String publicAddress;
    final String balance;
    final int user;

    GetWallet({
        required this.id,
        required this.mnemonic,
        required this.publicAddress,
        required this.balance,
        required this.user,
    });

    factory GetWallet.fromJson(Map<String, dynamic> json) => GetWallet(
        id: json["id"],
        mnemonic: json["mnemonic"],
        publicAddress: json["public_address"],
        balance: json["balance"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mnemonic": mnemonic,
        "public_address": publicAddress,
        "balance": balance,
        "user": user,
    };
}
