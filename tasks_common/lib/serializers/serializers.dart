import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:tasks_common/models.dart';

part 'serializers.jser.dart';

@GenSerializer(ignore: ['password', 'authorizationId'])
class UserSerializer extends Serializer<User> with _$UserSerializer {}

@GenSerializer()
class TaskSerializer extends Serializer<Task> with _$TaskSerializer {}
