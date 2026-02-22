import 'package:macrotrace/domain/services/id_service.dart';
import 'package:uuid/uuid.dart';

class UuidService implements IdService {
  final Uuid _uuid;

  UuidService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  @override
  String generateId() {
    return _uuid.v4();
  }
}
