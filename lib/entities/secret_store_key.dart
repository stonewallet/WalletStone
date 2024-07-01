enum SecretStoreKey { moneroWalletPassword, pinCodePassword, backupPassword }

const moneroWalletPassword = "MONERO_WALLET_PASSWORD";
const pinCodePassword = "PIN_CODE_PASSWORD";
const backupPassword = "BACKUP_CODE_PASSWORD";

String generateStoreKeyFor({
  required SecretStoreKey key,
  String walletName = "",
}) {
  var key0 = "";

  switch (key) {
    case SecretStoreKey.moneroWalletPassword:
      {
        key0 = "${moneroWalletPassword}_${walletName.toUpperCase()}";
      }
      break;

    case SecretStoreKey.pinCodePassword:
      {
        key0 = pinCodePassword;
      }
      break;

    case SecretStoreKey.backupPassword:
      {
        key0 = backupPassword;
      }
      break;

    default:
      {}
  }

  return key0;
}
