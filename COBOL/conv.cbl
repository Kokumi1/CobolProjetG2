000100 IDENTIFICATION DIVISION.                                         00010001
000200 PROGRAM-ID. CONV.                                                00020002
000300 ENVIRONMENT DIVISION.                                            00030002
000400 DATA DIVISION.                                                   00040002
000500 WORKING-STORAGE SECTION.                                         00050002
000600 77 WS-PRICE       PIC 9(3)V99.                                   00060002
000700 77 WS-RATE        PIC 9V9999 VALUE 0.                            00070002
000800 77 ED-PRICE       PIC ZZ9.99.                                    00080002
000900                                                                  00090002
001000 LINKAGE SECTION.                                                 00100002
001100 77 LS-DEVISE      PIC X(2).                                      00110002
001200 77 LS-PRICE-TEXT  PIC X(10).                                     00120002
001300 77 LS-PRICE-USD   PIC 9(3)V99.                                   00130003
001400                                                                  00140002
001500 PROCEDURE DIVISION USING LS-DEVISE LS-PRICE-TEXT LS-PRICE-USD.   00150002
001600     DISPLAY 'BIENVENUE SUR MON SS PROG CONVERT V3'               00160003
001700     DISPLAY 'LS-DEVISE : ' LS-DEVISE                             00170002
001800     DISPLAY 'LS-PRICE-TEXT : ' LS-PRICE-TEXT                     00180002
001900                                                                  00190002
002000     COMPUTE WS-PRICE = FUNCTION NUMVAL-C(LS-PRICE-TEXT)          00200002
002100                                                                  00210002
002200     DISPLAY 'LS-PRICE-USD  : ' LS-PRICE-USD                      00220002
002300                                                                  00230002
002400     EVALUATE LS-DEVISE                                           00240002
002500     WHEN 'EU'                                                    00250002
002600         DISPLAY 'DANS EU ' WS-PRICE                              00260002
002700         COMPUTE LS-PRICE-USD = WS-PRICE * 1.06                   00270002
002800     WHEN 'DO'                                                    00280002
002900         DISPLAY 'DANS DO ' WS-PRICE                              00290002
003000         COMPUTE LS-PRICE-USD = WS-PRICE * 1.00                   00300002
003100     WHEN 'YU'                                                    00310002
003200         DISPLAY 'DANS YU ' WS-PRICE                              00320002
003300         COMPUTE LS-PRICE-USD = WS-PRICE * 0.14                   00330002
003400     WHEN OTHER                                                   00340002
003500         DISPLAY 'DEVISE NON REPERTORIEE '                        00350002
003600         MOVE 0 TO WS-RATE                                        00360002
003700     END-EVALUATE.                                                00370002
003800                                                                  00380002
003900     MOVE LS-PRICE-USD TO ED-PRICE                                00390002
004000     DISPLAY 'LS-PRICE-USD APRES CALCUL : ' ED-PRICE              00400002
004100     GOBACK.                                                      00410002
