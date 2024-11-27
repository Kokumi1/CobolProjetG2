000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. ASSEQP3.                                             00020000
000210                                                                  00021000
000220 DATA DIVISION.                                                   00022000
000230 WORKING-STORAGE SECTION.                                         00023000
000240 LINKAGE SECTION.                                                 00024000
000250 COPY TESTCONT.                                                   00025000
000260 01 TEST-NAME PIC X(30).                                          00026001
000270 01 EXPECTED PIC X(30).                                           00027001
000280 01 ACTUAL   PIC X(30).                                           00028001
000290 PROCEDURE DIVISION USING TEST-CONTEXT, TEST-NAME,                00029000
000300                          EXPECTED, ACTUAL.                       00030000
000400                                                                  00040000
000500      ADD 1 TO TESTS-RUN                                          00050000
000600      IF ACTUAL = EXPECTED THEN                                   00060000
000700               ADD 1 TO PASSES                                    00070000
000800      ELSE                                                        00080000
000900               DISPLAY 'FAILED : ' TEST-NAME                      00090000
001000               DISPLAY 'EXPECTED ' EXPECTED                       00100000
001100               DISPLAY 'ACTUAL : ' ACTUAL                         00110000
001210               ADD 1 TO FAILURES                                  00121000
001220      END-IF                                                      00122000
001240      GOBACK.                                                     00124000
