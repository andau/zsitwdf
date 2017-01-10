class ZCL_COFFEEMACHINE_TEST definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      getMaintainanceStatus for testing raising cx_static_check.
endclass.


class ZCL_COFFEEMACHINE_TEST implementation.

  method getMaintainanceStatus.
    DATA sensorValues type ref to ZCL_SENSOR_VALUES.
    DATA coffeemachine type ref to ZCL_COFFEEMACHINE.
    CREATE OBJECT sensorValues.
    CREATE OBJECT coffeemachine.
    sensorValues->addSensorValue( exporting pSensorname = `ZSENSOR_FILL_QUANTITY_WATER` pSensorValue = 60 ).
    sensorValues->addSensorValue( exporting pSensorname = `ZSENSOR_FILL_QUANTITY_BEANS` pSensorValue = 60 ).

    coffeemachine->setsensorvalues( sensorValues ).
    DATA(maintenanceMessages) = coffeemachine->calculateMaintenanceStatus( ).
    cl_abap_unit_assert=>assert_equals( EXP = 0 ACT = lines( maintenanceMessages ) ).
  endmethod.

endclass.