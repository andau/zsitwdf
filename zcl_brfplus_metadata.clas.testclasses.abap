class ZCL_BRFPLUS_METADATA_UNIT definition FOR TESTING.
"#AU Risk_Level Harmless
  PUBLIC SECTION.
  private section.
  CONSTANTS: techedFunctionId   type if_fdt_types=>id
                                VALUE '0241750C32391EE6B4BDF2BAC8533BFF',
             techedFunctionName type IF_FDT_TYPES=>NAME
                                VALUE 'TECHED_FUNCTION_STRING2NUMBER',
             sitWdfFunctionId   type if_fdt_types=>id
                                VALUE '0241750C32391EE6B4D8A1790D2D5E0C',
             sitWdfFunctionName type IF_FDT_TYPES=>NAME
                                VALUE 'COFFEE_MACHINE_STATUS'.

  METHODS: testGetFunctionDefinition FOR TESTING,
           testGetFunctionContextParams FOR TESTING,
           testGetFunctionId FOR TESTING.

ENDCLASS.

CLASS ZCL_BRFPLUS_METADATA_UNIT IMPLEMENTATION.

 method testGetFunctionDefinition.

   DATA(functionname) = ZCL_BRFPLUS_METADATA=>getfunctionname(
                                     pFunctionId = sitWdfFunctionId ).
   CL_AUNIT_ASSERT=>assert_equals( EXP = sitWdfFunctionName  ACT = functionName ).
 endmethod.

 method testGetFunctionContextParams.

   DATA(contextParams)  = ZCL_BRFPLUS_METADATA=>getFunctionContextParams(
                                       pFunctionId = sitWdfFunctionId ).
   CL_AUNIT_ASSERT=>assert_equals( EXP = 2  ACT = lines( contextParams ) ).

   read table contextParams with key name = 'ZSENSOR_FILL_QUANTITY_BEANS' into DATA(contextParam).
   CL_AUNIT_ASSERT=>assert_equals( EXP = 'T' ACT = contextParam-type  ).

   clear contextParam.
   read table contextParams with key name = 'SENSOR_NOT_EXISTING' into contextParam.
   CL_AUNIT_ASSERT=>assert_initial( contextParam ).

 endmethod.

 method testGetFunctionId.

    DATA(functionIdResult) = ZCL_BRFPLUS_METADATA=>getFunctionId(
                                        techedFunctionName  ).
    CL_AUNIT_ASSERT=>assert_equals( EXP = techedFunctionId ACT = functionIdResult ).

 endmethod.

ENDCLASS.