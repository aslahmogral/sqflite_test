class Wirdmodel {
  final int? id;
  final String? createdDate;
  final int? currentWird;
  final String? status;

  Wirdmodel({this.createdDate,this.currentWird,this.id,this.status});

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdDate': createdDate,
      'currentWird': currentWird,
      'status': status
    };
  }

  // Create a User from a Map object
  factory Wirdmodel.fromMap(Map<String, dynamic> map) {
    return Wirdmodel(
      id: map['id'],
      createdDate: map['createdDate'],
      currentWird: map['currentWird'],
      status: map['status'],     
    );
  }
}
