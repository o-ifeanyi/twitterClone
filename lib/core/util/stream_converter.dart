
import 'package:equatable/equatable.dart';

class StreamConverter extends Equatable{
  final Stream stream;

  StreamConverter({this.stream});

  @override
  List<Object> get props => [stream];
}