{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0  000001 //JPART1 JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,TIME=(0,20)          \
 000002 //*                                                                 \
 000003 //PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB                            \
 000004 //*                                                                 \
 000005 //         SET SYSUID=API5,                                         \
 000006 //             NOMPGM=PART1                                         \
 000007 //*                                                                 \
 000008 //APPROC   EXEC COMPDB2                                             \
 000009 //STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR           \
 000010 //*                DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR             \
 000011 //STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.DB2(&NOMPGM),DISP=SHR     \
 000012 //STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR \
 000013 //STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR  \
 000014 //*                                                                 \
 000015 //*--- ETAPE DE BIND --------------------------------------         \
 000016 //*                                                                 \
 000017 //BIND     EXEC PGM=IKJEFT01,COND=(4,LT)                           \
000018 //*DBRMLIB  DD  DSN=&SYSUID..DB2.DBRMLIB,DISP=SHR        \
000019 //DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR      \
000020 //SYSTSPRT DD  SYSOUT=*,OUTLIM=25000                     \
000021 //SYSTSIN  DD  *                                         \
000022   DSN SYSTEM (DSN1)                                      \
000023   BIND PLAN      (PART1) -                               \
000024        QUALIFIER (API5)    -                             \
000025        ACTION    (REPLACE) -                             \
000026        MEMBER    (PART1) -                               \
000027        VALIDATE  (BIND)    -                             \
000028        ISOLATION (CS)      -                             \
000029        ACQUIRE   (USE)     -                             \
000030        RELEASE   (COMMIT)  -                             \
000031        EXPLAIN   (NO)                                    \
000032 /*                                                       \
000033 //STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)                 \
000034 //STEPLIB  DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR\
000035 //         DD DSN=&SYSUID..COBOL.LOAD,DISP=SHR          \
000036 //SYSOUT   DD  SYSOUT=*,OUTLIM=1000                     \
000037 //SYSTSPRT DD  SYSOUT=*,OUTLIM=2500                     \
000038 //NEWPRODS DD DSN=API5.PROJET.NEWPRODS.DATA,DISP=SHR    \
000039 //SYSTSIN  DD  *                                        \
000040   DSN SYSTEM (DSN1)                                     \
000041   RUN PROGRAM(PART1) PLAN (PART1)                       \
000042 /*                                                      \
000043 //SYSIN    DD *                                         \
000044 10                                                      \
000045 /*                                                              }