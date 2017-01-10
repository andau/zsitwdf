class ZCL_BRFPLUS_METADATA_V2 definition
  public
  final
  create public .

public section.

CLASS-METHODS: getFunctionId importing pFunctionname type IF_FDT_TYPES=>NAME
                             returning value(pFunctionId) type IF_FDT_TYPES=>ID.
ENDCLASS.



CLASS ZCL_BRFPLUS_METADATA_V2 IMPLEMENTATION.

method GetFunctionId.


  DATA(fdtFactory) = CL_FDT_FACTORY=>get_instance( exporting iv_application_id = pFunctionId ).
  DATA(objectType) = if_fdt_constants=>gc_object_type_function.

  DATA(fdtQuery) = fdtFactory->get_query( exporting iv_object_type = objectType ).
  fdtQuery->get_ids( exporting iv_name = pFunctionname
                     importing ets_object_id = DATA(objectIds) ).

  read table objectIds INDEX 1 into pFunctionId.

endmethod.

ENDCLASS.