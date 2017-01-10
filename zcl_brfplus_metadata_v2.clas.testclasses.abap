class ZCL_BRFPLUS_METADATA_A_UNIT definition FOR TESTING.
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

  METHODS: testGetFunctionId FOR TESTING.

ENDCLASS.

CLASS ZCL_BRFPLUS_METADATA_A_UNIT IMPLEMENTATION.


 method testGetFunctionId.

    DATA(functionIdResult) = ZCL_BRFPLUS_METADATA_V2=>getFunctionId(
                                        techedFunctionName  ).
    CL_AUNIT_ASSERT=>assert_equals( EXP = techedFunctionId ACT = functionIdResult ).

 endmethod.

ENDCLASS.