000100 IDENTIFICATION DIVISION.                                         00010001
000200 PROGRAM-ID. TCONV.                                               00020001
000300 ENVIRONMENT DIVISION.                                            00030001
000400 DATA DIVISION.                                                   00040001
000500 WORKING-STORAGE SECTION.                                         00050001
000600                                                                  00060001
000700 01  INPUT-DEVISE       PIC X(2).                                 00070001
000710 01  INPUT-PRICE-TEXT   PIC X(10).                                00071004
000800                                                                  00080001
000900 01  RES                PIC 9(3)V99.                              00090003
001000 01  EXPECTED-RES       PIC 9(3)V99.                              00100003
001100 01  LIB PIC X(30).                                               00110001
001200 01  L-SEP PIC X(30) VALUE ALL "*".                               00120001
001300                                                                  00130001
001400 LINKAGE SECTION.                                                 00140001
001500 COPY TESTCONT.                                                   00150001
001600                                                                  00160001
001700 PROCEDURE DIVISION USING TEST-CONTEXT.                           00170001
001800                                                                  00180001
001900     PERFORM TEST-CONV-EU.                                        00190001
002000     DISPLAY 'RUN ', TESTS-RUN, ' OK ', PASSES, ' KO ', FAILURES  00200001
002100     DISPLAY L-SEP                                                00210001
003000                                                                  00300001
003010     PERFORM TEST-CONV-DO.                                        00301005
003020     DISPLAY 'RUN ', TESTS-RUN, ' OK ', PASSES, ' KO ', FAILURES  00302005
003030     DISPLAY L-SEP                                                00303005
003040                                                                  00304005
003050     PERFORM TEST-CONV-YU.                                        00305005
003060     DISPLAY 'RUN ', TESTS-RUN, ' OK ', PASSES, ' KO ', FAILURES  00306005
003070     DISPLAY L-SEP                                                00307005
003080                                                                  00308005
003100     GOBACK.                                                      00310001
003200                                                                  00320001
003300 TEST-CONV-EU.                                                    00330001
003400     MOVE 1 TO RES                                                00340001
003500     MOVE '10.00' TO INPUT-PRICE-TEXT                             00350001
003600     MOVE 10.60   TO EXPECTED-RES                                 00360001
003700     MOVE 'EU'    TO INPUT-DEVISE                                 00370001
003800     MOVE 'TEST-CONV-EU' TO LIB                                   00380001
003900                                                                  00390001
004000     CALL 'CONV' USING BY CONTENT INPUT-DEVISE                    00400001
004100                       BY CONTENT INPUT-PRICE-TEXT                00410001
004200                       BY REFERENCE  RES                          00420001
004300                                                                  00430001
004400     DISPLAY "******** ", LIB, "*********"                        00440001
004500     CALL 'ASSEQ' USING TEST-CONTEXT, LIB,                        00450001
004600                        EXPECTED-RES, RES                         00460001
004700     .                                                            00470001
004800                                                                  00480001
004900 TEST-CONV-DO.                                                    00490005
005000     MOVE 1 TO RES                                                00500005
005100     MOVE '10.00' TO INPUT-PRICE-TEXT                             00510005
005200     MOVE 10.00   TO EXPECTED-RES                                 00520005
005300     MOVE 'DO'    TO INPUT-DEVISE                                 00530005
005400     MOVE 'TEST-CONV-DO' TO LIB                                   00540005
005500                                                                  00550005
005600     CALL 'CONV' USING BY CONTENT INPUT-DEVISE                    00560005
005700                       BY CONTENT INPUT-PRICE-TEXT                00570005
005800                       BY REFERENCE  RES                          00580005
005900                                                                  00590005
006000     DISPLAY "******** ", LIB, "*********"                        00600005
006100     CALL 'ASSEQ' USING TEST-CONTEXT, LIB,                        00610005
006200                        EXPECTED-RES, RES                         00620005
006300     .                                                            00630005
006400                                                                  00640005
006500 TEST-CONV-YU.                                                    00650005
006600     MOVE 1 TO RES                                                00660005
006700     MOVE '10.00' TO INPUT-PRICE-TEXT                             00670005
006800     MOVE  1.40   TO EXPECTED-RES                                 00680005
006900     MOVE 'YU'    TO INPUT-DEVISE                                 00690005
007000     MOVE 'TEST-CONV-YU' TO LIB                                   00700005
007100                                                                  00710005
007200     CALL 'CONV' USING BY CONTENT INPUT-DEVISE                    00720005
007300                       BY CONTENT INPUT-PRICE-TEXT                00730005
007400                       BY REFERENCE  RES                          00740005
007500                                                                  00750005
007600     DISPLAY "******** ", LIB, "*********"                        00760005
007700     CALL 'ASSEQ' USING TEST-CONTEXT, LIB,                        00770005
007800                        EXPECTED-RES, RES                         00780005
007900     .                                                            00790005
008000                                                                  00800005
