class zcl_coffeemachine definition
  public
  final
  create public .

public section.
    methods: calculateMaintenanceStatus  returning  value(pMaintenanceMessages) type ZT_MAINTENANCE_MESSAGES,
             setSensorValues importing pSensorValues type ref to ZCL_SENSOR_VALUES.

protected section.
private section.
  DATA sensorValues type ref to ZCL_SENSOR_VALUES.
endclass.



class zcl_coffeemachine implementation.

  method calculateMaintenanceStatus.
      DATA(brfplusFunction) = NEW zcl_brfplus_function( ).
      pMaintenanceMessages = brfplusFunction->process(
            exporting pFunctionName = `COFFEE_MACHINE_STATUS`
                      pSensorValues = sensorValues ).
  endmethod.

  method setSensorValues.
    sensorValues = pSensorValues.
  endmethod.

endclass.