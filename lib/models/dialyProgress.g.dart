// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialyProgress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyProgressAdapter extends TypeAdapter<DailyProgress> {
  @override
  final int typeId = 0;

  @override
  DailyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyProgress(
      habitId: fields[0] as String,
      date: fields[1] as DateTime,
      completedUnits: fields[2] as int,
      isCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.habitId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.completedUnits)
      ..writeByte(3)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
