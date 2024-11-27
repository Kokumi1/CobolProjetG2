000100 IDENTIFICATION DIVISION.                                         00010001
000200 PROGRAM-ID. P3TEST.                                              00020001
000300 ENVIRONMENT DIVISION.                                            00030001
000400 DATA DIVISION.                                                   00040001
000500 WORKING-STORAGE SECTION.                                         00050001
000600                                                                  00060001
000700 01  TEST-DATE-TEXT       PIC X(30).                              00070001
000800 01  EXPECTED-DATE-TEXT   PIC X(30).                              00080001
000900 01  RES                  PIC X(30).                              00090001
001000 01  LIB                  PIC X(30).                              00100001
001100 01  L-SEP                PIC X(30) VALUE ALL "*".                00110001
001101                                                                  00110105
001110 01  TODAY-DATE           PIC X(6).                               00111005
001130 01  DAY-NUMBER           PIC 99.                                 00113002
001140 01  MONTH-NUMBER         PIC 99.                                 00114002
001150 01  YEAR                 PIC X(4).                               00115014
001160 01  MONTH-NAME           PIC X(10).                              00116002
001170 01  DAY-NAME             PIC X(10).                              00117002
001180                                                                  00118005
001200 LINKAGE SECTION.                                                 00120001
001500 COPY TESTCONT.                                                   00150001
001650                                                                  00165018
001700 PROCEDURE DIVISION USING TEST-CONTEXT.                           00170001
001800                                                                  00180005
001810     MOVE ZERO TO FAILURES                                        00181019
001830     PERFORM TEST-SPDATE-FR                                       00183009
001831     DISPLAY 'RUN ', TESTS-RUN, ' OK ', PASSES, ' KO ', FAILURES  00183109
001832     DISPLAY L-SEP                                                00183209
001833     GOBACK.                                                      00183305
001834                                                                  00183405
001835 TEST-SPDATE-FR.                                                  00183506
001837     MOVE "TEST-SPDATE-FR" TO LIB                                 00183709
001839     ACCEPT TODAY-DATE FROM DATE                                  00183909
001840     DISPLAY "TODAY-DATE: " TODAY-DATE                            00184009
001841                                                                  00184108
001850     MOVE TODAY-DATE(1:2) TO YEAR                                 00185009
001860     MOVE TODAY-DATE(3:2) TO MONTH-NUMBER                         00186009
001870     MOVE TODAY-DATE(5:2) TO DAY-NUMBER                           00187009
001880                                                                  00188008
001881     DISPLAY 'TODAY-DATE(1:2) : ' TODAY-DATE(1:2)                 00188114
001882     DISPLAY 'YEAR FIRST : ' YEAR                                 00188214
001883                                                                  00188314
001884                                                                  00188414
001890     IF YEAR >= 50 THEN                                           00189005
001900        STRING "19" YEAR DELIMITED BY SIZE INTO YEAR              00190005
001910        END-STRING                                                00191014
002000     ELSE                                                         00200005
002100        STRING                                                    00210014
002101          "20" DELIMITED BY SIZE                                  00210114
002102          TODAY-DATE(1:2) DELIMITED BY SIZE                       00210216
002104          INTO YEAR                                               00210414
002110        END-STRING                                                00211014
002200     END-IF                                                       00220005
002210     DISPLAY "CONVERTED YEAR: " YEAR                              00221009
002220                                                                  00222008
002230     EVALUATE MONTH-NUMBER                                        00223010
002240        WHEN "01"                                                 00224010
002250           MOVE "JANVIER" TO MONTH-NAME                           00225010
002260        WHEN "02"                                                 00226010
002270           MOVE "FEVRIER" TO MONTH-NAME                           00227010
002280        WHEN "03"                                                 00228010
002290           MOVE "MARS" TO MONTH-NAME                              00229010
002300        WHEN "04"                                                 00230010
002400           MOVE "AVRIL" TO MONTH-NAME                             00240010
002500        WHEN "05"                                                 00250010
002600           MOVE "MAI" TO MONTH-NAME                               00260010
002700        WHEN "06"                                                 00270010
002800           MOVE "JUIN" TO MONTH-NAME                              00280010
002900        WHEN "07"                                                 00290010
003000           MOVE "JUILLET" TO MONTH-NAME                           00300010
003100        WHEN "08"                                                 00310010
003200           MOVE "AOUT" TO MONTH-NAME                              00320010
003300        WHEN "09"                                                 00330010
003400           MOVE "SEPTEMBRE" TO MONTH-NAME                         00340010
003500        WHEN "10"                                                 00350010
003600           MOVE "OCTOBRE" TO MONTH-NAME                           00360010
003700        WHEN "11"                                                 00370010
003800           MOVE "NOVEMBRE" TO MONTH-NAME                          00380010
003900        WHEN "12"                                                 00390010
004000           MOVE "DECEMBRE" TO MONTH-NAME                          00400010
004700        WHEN OTHER                                                00470010
004800           MOVE "MOIS INCONNU" TO MONTH-NAME                      00480010
004900     END-EVALUATE                                                 00490010
004910     DISPLAY "MONTH-NAME: " MONTH-NAME                            00491009
005000                                                                  00500005
005100     MOVE "JEUDI" TO DAY-NAME                                     00510010
005110     DISPLAY "DAY-NAME: " DAY-NAME                                00511009
005200                                                                  00520005
005300*    STRING "JEUDI 21 NOVEMBRE 2024" DELIMITED BY SIZE INTO       00530011
005400*    EXPECTED-DATE-TEXT.                                          00540011
005410*    DISPLAY "EXPECTED-DATE-TEXT: " EXPECTED-DATE-TEXT            00541011
005500                                                                  00550005
005600*    STRING DAY-NAME DELIMITED BY SPACE                           00560011
005700*           DAY-NUMBER DELIMITED BY SPACE                         00570011
005800*           MONTH-NAME DELIMITED BY SPACE                         00580011
005900*           YEAR DELIMITED BY SPACE                               00590011
006000*    INTO TEST-DATE-TEXT.                                         00600011
006010*    DISPLAY "TEST-DATE-TEST: " TEST-DATE-TEXT                    00601011
006100                                                                  00610005
006101     STRING DAY-NAME DELIMITED BY SPACE                           00610111
006102            ' ' DELIMITED BY SIZE                                 00610217
006103            DAY-NUMBER DELIMITED BY SPACE                         00610311
006104            ' ' DELIMITED BY SIZE                                 00610417
006105            MONTH-NAME DELIMITED BY SPACE                         00610511
006106            ' ' DELIMITED BY SIZE                                 00610617
006107            YEAR DELIMITED BY SPACE                               00610711
006108     INTO EXPECTED-DATE-TEXT                                      00610811
006110                                                                  00611011
006113                                                                  00611311
006120     CALL 'SPDATE' USING BY REFERENCE TEST-DATE-TEXT              00612013
006130                                                                  00613011
006202                                                                  00620211
006203                                                                  00620311
006210     DISPLAY "******** ", LIB, " ********"                        00621011
006300     DISPLAY "TEST-DATE-TEXT: ", TEST-DATE-TEXT                   00630009
006400     DISPLAY "EXPECTED-DATE-TEXT: ", EXPECTED-DATE-TEXT           00640009
006500     CALL 'ASSEQP3' USING TEST-CONTEXT, LIB,                      00650008
006600                 EXPECTED-DATE-TEXT, TEST-DATE-TEXT.              00660005
