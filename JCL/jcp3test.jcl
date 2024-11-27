{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 000001 //JCP3TEST JOB (ACCT#),'ELIAS',MSGCLASS=H,REGION=4M,            \
000002 //    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)         \
000003 //*                                                             \
000004 //*  ETAPE DE COMPILATION                                       \
000005 //*                                                             \
000006 //COMPIL   EXEC IGYWCL,PARM.COBOL=(ADV,OBJECT,LIB,TEST,APOST)   \
000007 //COBOL.SYSIN  DD DSN=API5.SOURCE.COBOL(P3TEST),DISP=SHR        \
000008 //COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR                     \
000009 //             DD DSN=API5.SOURCE.COPY,DISP=SHR                 \
000010 //*                                                             \
000011 //*  ETAPE DE LINKEDIT                                          \
000012 //*                                                             \
000013 //LKED.SYSLIB  DD DSN=API5.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)      \
000014 //LKED.SYSLMOD DD DSN=API5.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)      \
000015 //LKED.SYSIN DD *                                               \
000016  INCLUDE SYSLIB('ASSEQP3')                                      \
000017  INCLUDE SYSLIB('SPDATE')                                       \
000018  NAME P3TEST(R)     \
000019 /*                  }