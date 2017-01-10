class zcl_sensor_values definition
  public
  final
  create public .

public section.

  TYPES ty_sensorvalues type table of zstruct_sensor_value.
  METHODS: getSensorValues exporting pSensorValues TYPE ty_sensorvalues,
           addSensorValue importing pSensorname  type string   pSensorvalue TYPE int2.
protected section.
private section.
  DATA sensorValues type table of zstruct_sensor_value.
endclass.

class zcl_sensor_values implementation.
  method getSensorValues.
    pSensorValues = me->sensorvalues.
  endmethod.


  method addSensorValue.
     DATA sensorValue type zstruct_sensor_value.
     sensorValue-name = pSensorname.
     sensorValue-value = pSensorvalue.
     append sensorValue to sensorValues.
  endmethod.

endclass.