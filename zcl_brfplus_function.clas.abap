class zcl_brfplus_function definition
  public
  final
  create public .

public section.
    class-methods process
      importing pFunctionname type IF_FDT_TYPES=>NAME
                pSensorValues type ref to ZCL_SENSOR_VALUES
      returning
        value(pMaintenanceMessages) type ZT_MAINTENANCE_MESSAGES.
protected section.
private section.
endclass.



class zcl_brfplus_function implementation.

  method process.
    DATA: contextParams TYPE abap_parmbind_tab,
          contextparam like line of contextParams.
    FIELD-SYMBOLS <resultDataAny> TYPE any.

    GET TIME STAMP FIELD DATA(currentTimestamp).

    "get defined context params of brfplus function
    DATA(functionId) = zcl_brfplus_metadata=>getFunctionId( pFunctionname  ).
    DATA(definedContextParams) = zcl_brfplus_metadata=>getfunctioncontextparams( functionId ).

    "build context information by matching defined context params and sensor values
    pSensorValues->getSensorValues( importing pSensorValues = DATA(sensorValues) ).
    loop at definedContextParams assigning field-symbol(<definedContextParam>).
      loop at sensorValues assigning field-symbol(<sensorvalue>).
        if <definedContextParam>-name = <sensorvalue>-name.
          "move definedcontextParams into context params format for BRFplus call.
          contextparam-name = <definedContextParam>-name.
          GET REFERENCE OF <sensorvalue>-value INTO contextparam-value.
          INSERT contextparam INTO TABLE contextparams.
        endif.
      endloop.
   endloop.

   "prepare and process BRFplus function
   cl_fdt_function_process=>get_data_object_reference( EXPORTING iv_function_id      = functionId
                                                                iv_data_object      = 'ZTABLE_MAINTAINANCE_MESSAGES'
                                                                iv_timestamp        = currentTimestamp
                                                                iv_trace_generation = abap_false
                                                      IMPORTING er_data             = DATA(resultData) ).
   ASSIGN resultData->* TO <resultDataAny>.

  cl_fdt_function_process=>process( EXPORTING iv_function_id = functionId
                                              iv_timestamp   = currentTimestamp
                                    IMPORTING ea_result      = <resultDataAny>
                                    CHANGING  ct_name_value  = contextParams ).


  "return result of brfplus function
  pMaintenanceMessages = <resultDataAny>.

  endmethod.

endclass.