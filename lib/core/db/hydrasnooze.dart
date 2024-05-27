import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part "hydrasnooze.g.dart";

const userTable = SqfEntityTable(
    tableName: 'UserTable',
    primaryKeyName: 'uid',
    primaryKeyType: PrimaryKeyType.text,
    useSoftDeleting: true,
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField(
        'email',
        DbType.text,
      ),
      SqfEntityField('dob', DbType.text),
      SqfEntityField('gender', DbType.text),
      SqfEntityField('weight', DbType.integer),
      SqfEntityField('wakeUpTime', DbType.text),
      SqfEntityField('photoUrl', DbType.text),
      SqfEntityField('waterGoal', DbType.integer),
    ]);

const alarmModel = SqfEntityTable(
  tableName: "AlarmModel",
  primaryKeyName: "id",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField("label", DbType.text),
    SqfEntityFieldRelationship(
      parentTable: userTable,
      fieldName: 'uid',
      relationType: RelationType.ONE_TO_MANY,
    ),
    SqfEntityField("alarmTime", DbType.text),
    SqfEntityField("doRepeat", DbType.bool),
    SqfEntityField("isActive", DbType.bool),
  ],
);

@SqfEntityBuilder(hydrasnooze)
const hydrasnooze = SqfEntityModel(
  modelName: 'Hydrasnooze', // optional
  databaseName: 'hydrasnooze.db',
  databaseTables: [
    userTable,
    alarmModel,
  ],
  bundledDatabasePath: null,
);
