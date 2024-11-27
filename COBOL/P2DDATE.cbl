000100 IDENTIFICATION DIVISION.                                         00010000
000200 PROGRAM-ID. P2DDATE.                                             00020003
000300*****************************************                         00030000
000400 ENVIRONMENT DIVISION.                                            00040000
000500 CONFIGURATION SECTION.                                           00050000
000600 SPECIAL-NAMES.                                                   00060000
000700     DECIMAL-POINT IS COMMA.                                      00070000
000710                                                                  00071000
000720 DATA DIVISION.                                                   00072000
000730 WORKING-STORAGE SECTION.                                         00073000
000740 77 WS-RES       PIC X(10).                                       00074000
000741                                                                  00074100
000742 LINKAGE SECTION.                                                 00074200
000743 77 LS-RES       PIC X(10).                                       00074300
000744                                                                  00074400
000745 01 LS-INPUT.                                                     00074500
000746    05 WS-DAY    PIC X(02).                                       00074605
000747    05 FILLER    PIC X(01).                                       00074700
000748    05 WS-MOIS   PIC X(02).                                       00074800
000749    05 FILLER    PIC X(01).                                       00074900
000750    05 WS-AN     PIC X(04).                                       00075005
000760                                                                  00076000
000770 PROCEDURE DIVISION USING LS-INPUT LS-RES.                        00077000
000780                                                                  00078000
000787      STRING                                                      00078700
000788        WS-AN DELIMITED BY SPACE                                  00078800
000789        '-' DELIMITED BY SIZE                                     00078900
000790        WS-MOIS DELIMITED BY SPACE                                00079000
000791        '-' DELIMITED BY SIZE                                     00079100
000800        WS-DAY DELIMITED BY SPACE                                 00080000
000900        INTO WS-RES                                               00090000
001000        ON OVERFLOW                                               00100000
001100           DISPLAY 'WS-RES ZONE TROP PETITE'                      00110000
001200        NOT ON OVERFLOW                                           00120000
001400           MOVE WS-RES TO LS-RES                                  00140000
001500      END-STRING                                                  00150000
001600                                                                  00160000
001700      GOBACK.                                                     00170000
001800                                                                  00180000
