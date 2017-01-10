class ZCL_BRFPLUS_METADATA_V3 definition
  public
  final
  create public .

public section.

CLASS-METHODS: getFunctionId importing pFunctionname type IF_FDT_TYPES=>NAME
                             returning value(pFunctionId) type IF_FDT_TYPES=>ID.
ENDCLASS.



CLASS ZCL_BRFPLUS_METADATA_V3 IMPLEMENTATION.


method GetFunctionId.

  CL_FDT_FACTORY=>get_instance( pFunctionId )->get_query(
        iv_object_type = if_fdt_constants=>gc_object_type_function )->get_ids(
                     exporting iv_name = pFunctionname
                     importing ets_object_id = DATA(idsOfMatchingFunctions) ) .

  pFunctionId = idsOfMatchingFunctions[ 1 ].

endmethod.
ENDCLASS.