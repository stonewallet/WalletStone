
class Contacts {
    final int? id;
    final String? contactName;
    final int? user;

    Contacts({
         this.id,
         this.contactName,
         this.user,
    });

    factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
        id: json["id"],
        contactName: json["contact_name"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "user": user,
    };
}
