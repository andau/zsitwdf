class ZCL_BRFPLUS_METADATA definition
  public
  final
  create public .

public section.

CLASS-METHODS: getFunctionId
                     importing pFunctionname type IF_FDT_TYPES=>NAME
                     returning value(pFunctionId) type IF_FDT_TYPES=>ID,


               getFunctionContextParams
                     importing pFunctionId type if_fdt_types=>id
                     returning  value(pContextParams) type ZT_CONTEXT_PARAMS,



               getFunctionName
                     importing pFunctionId type if_fdt_types=>id
                     returning  value(pFunctionName) type IF_FDT_TYPES=>NAME.

protected section.
private section.
ENDCLASS.



CLASS ZCL_BRFPLUS_METADATA IMPLEMENTATION.



method GetFunctionId.

* get function Id by searching the BRFplus application by the function name
  CL_FDT_FACTORY=>get_instance(  )->get_query(
        iv_object_type = if_fdt_constants=>gc_object_type_function )->get_ids(
                     exporting iv_name = pFunctionname
                     importing ets_object_id = DATA(idsOfMatchingFunctions) ) .

* returning first found id
  pFunctionId = idsOfMatchingFunctions[ 1 ].

endmethod.






method getFunctionContextParams.
  DATA: contextParam like line of pContextParams.

* get all context Ids
  DATA(contextObjectIds) = CL_FDT_FACTORY=>get_instance(
                                )->get_function( pFunctionId )->get_context_data_objects( ).

  LOOP AT contextObjectIds assigning FIELD-SYMBOL(<contextObjectId>).

* get instance by context id
      CL_FDT_FACTORY=>get_instance_generic(
                    EXPORTING iv_id         = <contextObjectId>
                    IMPORTING eo_instance   = DATA(lo_instance) ).

* populate result table
      contextParam-name = lo_instance->get_name( ).
      contextParam-type = CONV string( CAST if_fdt_element( lo_instance )->get_element_type( ) ).
      append contextParam to pContextParams.

  ENDLOOP.

endmethod.



method getFunctionName.

  CL_FDT_FACTORY=>get_instance_generic(
             EXPORTING iv_id    = pFunctionId
             IMPORTING eo_instance   = DATA(lo_instance) ).

  pFunctionName = lo_instance->get_name( ).

endmethod.
ENDCLASS.