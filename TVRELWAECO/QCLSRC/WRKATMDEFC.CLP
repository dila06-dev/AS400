/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             IF         COND(&USER *EQ 'GANG' ) THEN(DO)
                WRKATMDEF
             ENDDO
/*                                                                            */
 ENDPGM:

             ENDPGM
