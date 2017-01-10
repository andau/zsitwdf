class ltcl_ definition final for testing
  duration short
  risk level harmless.

  private section.
    DATA brfplusFunction type ref to zcl_brfplus_function.
    methods:
      setup,
      okTest2Sensors for testing raising cx_static_check,
      okTest3Sensors for testing raising cx_static_check,
      okTest2SensorsWithInputFrom3 for testing raising cx_static_check,
      failTest2Sensors for testing raising cx_static_check,

      generateDataFor2Sensors
         importing pSensorFillQuantityBeans type int2
                   pSensorFillQuantityWater type int2
         returning value(pSensorValues) type ref to ZCL_SENSOR_VALUES,
      generateDataFor3Sensors
         importing pSensorFillQuantityBeans type int2
                   pSensorFillQuantityWater type int2
                   pSensorFillQuantityTrash type int2
         returning value(pSensorValues) type ref to ZCL_SENSOR_VALUES.

endclass.


class ltcl_ implementation.

  method setup.
    create object brfplusFunction.
  endmethod.

  method okTest2Sensors.

    DATA(sensorValues) = generateDataFor2Sensors( exporting pSensorFillQuantityBeans = 80
                                                                pSensorFillQuantityWater = 80 ).
    DATA(maintenanceMessages) = brfplusFunction->process( exporting pFunctionName = `COFFEE_MACHINE_STATUS` pSensorValues = sensorValues ).


    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( maintenanceMessages ) ).

  endmethod.

  method okTest3Sensors.

    DATA(sensorValues) = generateDataFor3Sensors( exporting pSensorFillQuantityBeans = 80
                                                            pSensorFillQuantityWater = 80
                                                            pSensorFillQuantityTrash = 20    ).
    DATA(maintenanceMessages) = brfplusFunction->process( exporting pFunctionName = `COFFEE_MACHINE_STATUS_3SENSORS` pSensorValues = sensorValues ).


    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( maintenanceMessages ) ).

 endmethod.

  method okTest2SensorsWithInputFrom3.

    DATA(sensorValues) = generateDataFor3Sensors( exporting pSensorFillQuantityBeans = 80
                                                            pSensorFillQuantityWater = 80
                                                            pSensorFillQuantityTrash = 80 ).
    DATA(maintenanceMessages) = brfplusFunction->process( exporting pFunctionName = `COFFEE_MACHINE_STATUS` pSensorValues = sensorValues ).

    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( maintenanceMessages ) ).

  endmethod.

  method failTest2Sensors.

    DATA(sensorValues) = generateDataFor2Sensors( exporting pSensorFillQuantityBeans = 20
                                                            pSensorFillQuantityWater = 80 ).
    DATA(maintenanceMessages) = brfplusFunction->process( exporting pFunctionName = `COFFEE_MACHINE_STATUS` pSensorValues = sensorValues ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( maintenanceMessages ) ).

    sensorValues = generateDataFor2Sensors( exporting pSensorFillQuantityBeans = 80
                                                      pSensorFillQuantityWater = 10 ).
    maintenanceMessages = brfplusFunction->process( exporting pFunctionName = `COFFEE_MACHINE_STATUS` pSensorValues = sensorValues ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( maintenanceMessages ) ).

  endmethod.


  method generateDataFor2Sensors.

    create object pSensorValues.
    pSensorValues->addSensorValue( pSensorname = `ZSENSOR_FILL_QUANTITY_BEANS`
                                 pSensorValue = pSensorFillQuantityBeans  ).
    pSensorValues->addSensorValue( pSensorname = `ZSENSOR_FILL_QUANTITY_WATER`
                                 pSensorValue = pSensorFillQuantityWater ).
  endmethod.

  method generateDataFor3Sensors.

    create object pSensorValues.
    pSensorValues->addSensorValue( pSensorname = `ZSENSOR_FILL_QUANTITY_BEANS`
                                 pSensorValue = pSensorFillQuantityBeans  ).
    pSensorValues->addSensorValue( pSensorname = `ZSENSOR_FILL_QUANTITY_WATER`
                                 pSensorValue = pSensorFillQuantityWater ).
    pSensorValues->addSensorValue( pSensorname = `ZSENSOR_FILL_QUANTITY_TRASH`
                                 pSensorValue = pSensorFillQuantityTrash ).

  endmethod.

endclass.