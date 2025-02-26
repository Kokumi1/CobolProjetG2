000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. PART4.                                               00020000
000300*****************************************                         00030000
000400 ENVIRONMENT DIVISION.                                            00040000
000500 CONFIGURATION SECTION.                                           00050000
000600 SPECIAL-NAMES.                                                   00060000
000700     DECIMAL-POINT IS COMMA.                                      00070000
000800                                                                  00080000
000900 INPUT-OUTPUT SECTION.                                            00090000
001000 FILE-CONTROL.                                                    00100000
001100     SELECT OUTXML ASSIGN TO FICXML.                              00110000
001102                                                                  00110200
001103*****************************************                         00110300
001104 DATA DIVISION.                                                   00110400
001105 FILE SECTION.                                                    00110500
001106 FD OUTXML.                                                       00110600
001107 01 ENR-OUTXML PIC X(71).                                         00110703
001400                                                                  00140000
001867 WORKING-STORAGE SECTION.                                         00186700
001868                                                                  00186800
001869     EXEC SQL                                                     00186900
001870        INCLUDE SQLCA                                             00187000
001880     END-EXEC.                                                    00188000
001890                                                                  00189013
001891     EXEC SQL INCLUDE ITEMS     END-EXEC.                         00189113
001892     EXEC SQL INCLUDE PRODUCTS  END-EXEC.                         00189213
001893                                                                  00189300
001894*****************************************                         00189413
001895*** REQUETE POUR RECUPERER LES PRODUITS                           00189547
001896*** PAR QUANTITé VENDUE DéCROISSANTE                              00189647
001897*****************************************                         00189747
001898     EXEC SQL                                                     00189847
001899        DECLARE CXML CURSOR                                       00189947
001900        FOR                                                       00190013
001901        SELECT I.P_NO,                                            00190113
001903               P.DESCRIPTION,                                     00190313
001905               SUM(I.QUANTITY) AS TOTAL_QUANTITY                  00190513
001915        FROM API5.ITEMS I                                         00191513
001917        JOIN API5.PRODUCTS P                                      00191713
001918        ON I.P_NO = P.P_NO                                        00191813
001919        GROUP BY I.P_NO, P.DESCRIPTION                            00191913
001920        ORDER BY TOTAL_QUANTITY DESC                              00192013
001927     END-EXEC.                                                    00192713
001928                                                                  00192813
001978 01 L-VENTES-OPEN    PIC X(8)  VALUE '<VENTES>'.                  00197813
001979 01 L-VENTES-CLOSE   PIC X(9)  VALUE '</VENTES>'.                 00197913
001980 01 L-PRODUCT-CLOSE  PIC X(12) VALUE '  </PRODUCT>'.              00198013
001981                                                                  00198113
001982 01 L-PRODUCT-OPEN.                                               00198213
001983    05 FILLER        PIC X(19) VALUE '  <PRODUCT NUMBER="'.       00198313
001984    05 PRODUCT-NO-ED PIC X(3).                                    00198417
001985    05 FILLER        PIC X(2)  VALUE '">'.                        00198513
001986                                                                  00198613
001987 01 L-RANG.                                                       00198718
001988    05 FILLER        PIC X(4)  VALUE SPACE.                       00198819
001989    05 FILLER        PIC X(6)  VALUE '<RANG>'.                    00198919
001990    05 RANG-NO-ED    PIC 99.                                      00199019
001991    05 FILLER        PIC X(7)  VALUE '</RANG>'.                   00199118
001992                                                                  00199218
001993 01 L-DESIGNATION PIC X(61).                                      00199346
002000                                                                  00200021
002001 01 L-VOLUME.                                                     00200121
002002    05 FILLER        PIC X(4)  VALUE SPACE.                       00200221
002003    05 FILLER        PIC X(8) VALUE '<VOLUME>'.                   00200321
002004    05 VOLUME-ED     PIC 999.                                     00200421
002005    05 FILLER        PIC X(9) VALUE '</VOLUME>'.                  00200521
002006                                                                  00200621
002007 77 WS-ANO               PIC 99    VALUE ZERO.                    00200721
002008 77 WS-TOTAL-QUANTITY    PIC S9(9) COMP.                          00200821
002009 77 WS-CPT-RANG          PIC 99    VALUE ZERO.                    00200921
002010                                                                  00201021
002011 01 WS-DESIG-TRIMMED    PIC X(30).                                00201122
002012 01 WS-DESIG-LEN        PIC 99 COMP.                              00201222
002013 01 WS-I                PIC 99 COMP.                              00201324
002014 01 WS-J                PIC 99 COMP.                              00201426
002015 01 WS-TEST-STRING    PIC X(30) VALUE '  TEST STRING   '.         00201530
002016 01 WS-TEST-LEN       PIC 99 COMP.                                00201630
002017                                                                  00201730
002018                                                                  00201830
002019 PROCEDURE DIVISION.                                              00201930
002020                                                                  00202030
002043     EXEC SQL                                                     00204330
002044        OPEN CXML                                                 00204430
002045     END-EXEC                                                     00204530
002046     PERFORM TEST-SQLCODE                                         00204630
002047                                                                  00204730
002048     OPEN OUTPUT OUTXML                                           00204830
002049                                                                  00204930
002058     PERFORM EXEC-SQL-FETCH-XML                                   00205830
002059     PERFORM TEST-SQLCODE                                         00205930
002060                                                                  00206030
002061     DISPLAY L-VENTES-OPEN                                        00206139
002062     WRITE ENR-OUTXML FROM L-VENTES-OPEN                          00206237
002063                                                                  00206330
002064     PERFORM UNTIL SQLCODE NOT EQUAL ZERO                         00206430
002119                                                                  00211932
002120        PERFORM PREPARE-DATA-TO-DISPLAY                           00212039
002121                                                                  00212139
002122        PERFORM SHOW-TOP-2-PRODUCTS                               00212240
002123                                                                  00212339
002124        PERFORM WRITE-PRODUCTS-TO-OUTPUT                          00212439
002141                                                                  00214135
002142        PERFORM EXEC-SQL-FETCH-XML                                00214235
002143        PERFORM TEST-SQLCODE                                      00214335
002144                                                                  00214435
002145     END-PERFORM                                                  00214535
002146                                                                  00214635
002147     DISPLAY L-VENTES-CLOSE                                       00214735
002148     WRITE ENR-OUTXML FROM L-VENTES-CLOSE                         00214837
002149                                                                  00214935
002150     CLOSE OUTXML                                                 00215035
002151                                                                  00215135
002152     EXEC SQL                                                     00215235
002153      CLOSE CXML                                                  00215335
002154     END-EXEC                                                     00215435
002155     PERFORM TEST-SQLCODE                                         00215535
002156                                                                  00215635
002157     GOBACK.                                                      00215735
002160                                                                  00216035
002170 PREPARE-DATA-TO-DISPLAY.                                         00217039
002172     ADD 1 TO WS-CPT-RANG                                         00217239
002173     MOVE WS-CPT-RANG TO RANG-NO-ED                               00217339
002174     MOVE ITEMS-P-NO TO PRODUCT-NO-ED                             00217439
002175     MOVE WS-TOTAL-QUANTITY TO VOLUME-ED                          00217539
002176                                                                  00217639
002181     MOVE SPACES TO L-DESIGNATION                                 00218146
002190     STRING                                                       00219044
002191         '    <DESIGNATION>' DELIMITED BY SIZE                    00219144
002192         PROD-DESCRIPTION-TEXT(1:PROD-DESCRIPTION-LEN)            00219245
002193         DELIMITED BY "  "                                        00219345
002194         '</DESIGNATION>' DELIMITED BY SIZE                       00219444
002195         INTO L-DESIGNATION                                       00219546
002196     END-STRING                                                   00219644
002203     .                                                            00220344
002204                                                                  00220444
002205 SHOW-TOP-2-PRODUCTS.                                             00220544
002206                                                                  00220644
002207     IF WS-CPT-RANG < 3 THEN                                      00220744
002208        DISPLAY L-PRODUCT-OPEN                                    00220844
002209        DISPLAY L-RANG                                            00220944
002210        DISPLAY L-DESIGNATION                                     00221046
002211        DISPLAY L-VOLUME                                          00221144
002212        DISPLAY L-PRODUCT-CLOSE                                   00221244
002213     END-IF                                                       00221344
002214     .                                                            00221444
002215                                                                  00221544
002216 WRITE-PRODUCTS-TO-OUTPUT.                                        00221644
002217     WRITE ENR-OUTXML FROM L-PRODUCT-OPEN                         00221744
002218     WRITE ENR-OUTXML FROM L-RANG                                 00221844
002219     WRITE ENR-OUTXML FROM L-DESIGNATION                          00221946
002220     WRITE ENR-OUTXML FROM L-VOLUME                               00222044
002221     WRITE ENR-OUTXML FROM L-PRODUCT-CLOSE                        00222144
002222     .                                                            00222244
002223                                                                  00222344
002224 EXEC-SQL-FETCH-XML.                                              00222444
002225     EXEC SQL                                                     00222544
002226        FETCH CXML                                                00222644
002230        INTO :ITEMS-P-NO,                                         00223016
002240             :PROD-DESCRIPTION,                                   00224016
002250             :WS-TOTAL-QUANTITY                                   00225016
002260     END-EXEC                                                     00226016
002500     .                                                            00250016
002600                                                                  00260016
004320 TEST-SQLCODE.                                                    00432013
004330     EVALUATE TRUE                                                00433013
004340          WHEN SQLCODE IS EQUAL TO ZERO                           00434013
004350                CONTINUE                                          00435013
004360          WHEN SQLCODE IS GREATER ZERO                            00436013
004370             IF SQLCODE = 100                                     00437013
004380               CONTINUE                                           00438013
004390             ELSE                                                 00439013
004400               DISPLAY 'WARNING : ' SQLCODE                       00440013
004500             END-IF                                               00450013
004510          WHEN SQLCODE IS LESS THAN ZERO                          00451013
004520                DISPLAY 'ANOMALIE : ' SQLCODE                     00452013
004530                PERFORM ABEND-PROG                                00453013
004540     END-EVALUATE.                                                00454013
004541                                                                  00454113
004550 ABEND-PROG.                                                      00455013
004570     COMPUTE WS-ANO = 1 / WS-ANO.                                 00457026
004580                                                                  00458026
