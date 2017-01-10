*&---------------------------------------------------------------------*
*& Status of coffeemachine
*&---------------------------------------------------------------------*
REPORT ZAMC_RECEIVE_COFFEEMACHINE.

PARAMETERS: status TYPE string DEFAULT 'WAIT FOR INPUT'.

DATA: gt_message_list TYPE TABLE OF string.

CLASS lcl_amc_test_text DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amc_message_receiver_pcp .
  PRIVATE SECTION.
    METHODS: callBrfPlusWithSensorData
               importing pPcpFields type pcp_fields
               returning value(pMaintenanceMessages) type ZT_MAINTENANCE_MESSAGES.
    DATA pcpFields type pcp_fields.
    DATA sensorValues type ref to ZCL_SENSOR_VALUES.
    DATA coffeemachine type ref to ZCL_COFFEEMACHINE.

ENDCLASS.

CLASS lcl_amc_test_text IMPLEMENTATION.



  METHOD if_amc_message_receiver_pcp~receive.
      create object coffeemachine.
      create object sensorValues.
      TRY.

         i_message->get_fields( CHANGING c_fields = pcpFields ).
         DATA(maintenanceMessages) = callBrfPlusWithSensorData( pcpFields ).

         if ( lines( maintenanceMessages ) = 0 ).
              APPEND 'STATE OK' TO gt_message_list.
         else.
              LOOP at maintenanceMessages assigning field-symbol(<maintenanceMessage>).
                APPEND <maintenanceMessage> TO gt_message_list.
              ENDLOOP.
         endif.

      CATCH cx_ac_message_type_pcp_error.
         MESSAGE `Unexpected error` type 'E'.
      ENDTRY.
    ENDMETHOD.




    METHOD callBrfPlusWithSensorData.
         loop at pPcpFields assigning field-symbol(<pcpField>).
            if <pcpField>-name CS 'ZSENSOR'.
               sensorValues->addsensorvalue( exporting pSensorname = <pcpField>-name
                                                    pSensorvalue = CONV int2( <pcpField>-value ) ).
            endif.
         endloop.

         coffeemachine->setsensorvalues(  sensorValues ).
         pMaintenanceMessages = coffeemachine->calculateMaintenancestatus( ).
    ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

TRY.
  DATA(lo_consumer) = cl_amc_channel_manager=>create_message_consumer(
    i_application_id = 'ZAMC_COFFEEMACHINE'
    i_channel_id = '/heartbeat' ).

  DATA(lo_receiver_text) = NEW lcl_amc_test_text( ).

  lo_consumer->start_message_delivery( i_receiver = lo_receiver_text ).
CATCH cx_amc_error INTO DATA(lx_amc_error).
     MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
ENDTRY.

  WAIT FOR MESSAGING CHANNELS UNTIL lines( gt_message_list ) >= 1 UP TO 2000 SECONDS.

  IF sy-subrc = 8 AND  lines( gt_message_list ) = 0.
     WRITE: ')-: Time out occured and no message received :-('.
  ELSE.
    LOOP AT gt_message_list INTO DATA(lv_message).
      WRITE: / sy-tabix, lv_message.
    ENDLOOP.
  ENDIF.