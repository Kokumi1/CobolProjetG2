000100  IDENTIFICATION DIVISION.                   
000200  PROGRAM-ID. PART1.                         
000500  ENVIRONMENT DIVISION.                      
000600  CONFIGURATION SECTION.                     
000700  SPECIAL-NAMES.                             
000800       DECIMAL-POINT IS COMMA.               
000900                                             
001000  INPUT-OUTPUT SECTION.                      
001100  FILE-CONTROL.                              
001200         SELECT NEWPRDS ASSIGN TO NEWPRODS   
001300          ORGANIZATION IS SEQUENTIAL.        
001510  DATA DIVISION.                             
001520  FILE SECTION.                              
001530  FD NEWPRDS.                                
001540  01 NEWPRODS-RECORD    PIC X(45).           
001560                                             
001570  WORKING-STORAGE SECTION.                   
001571      EXEC SQL                                
001572          INCLUDE SQLCA                       
001573      END-EXEC                                
001574      EXEC SQL                                
001575          INCLUDE PRODUCT                     
001576      END-EXEC                                
001577                                              
001580  01 DELIMITER-VAR  PIC X VALUE ";".          
001581  01 WS-DATA.                                 
001582   05 WS-PRO-ID       PIC X(3).               
001583   05 WS-DESCRIPTION  PIC X(20).              
001584   05 WS-DESC-FORM    PIC X(20).              
001585   05 WS-I            PIC 9(2) VALUE 1.       
001586   05 LETTRE-ACT      PIC X.                  
001587   05 MAJ             PIC X.                  
001588   05 MIN             PIC X.                  
001589   05 FIRST-WORD      PIC X VALUE 'O'.        
001590   05 POINT-OUT       PIC 9(2) VALUE 1.       
001591   05 WS-PRICE        PIC 9(3)V99.               
001592   05 WS-PRICE-TEXT   PIC X(10).                 
001593   05 WS-DEVISE       PIC X(2).                  
001594   05 WS-PRICE-USD    PIC 9(3)V99 COMP-3.        
001595   05 ED-PRICE-USD    PIC ZZ9,99.                
001596   05 WS-CONVERSION-RATE  PIC 9V9999.            
001597  01 WS-ANO  PIC 99 VALUE 12.                    
001598  01 WS-VAR  PIC 9  VALUE 0.                     
001599  01 WS-FLAG-END PIC 9 VALUE ZERO.               
001601   88 END-OF-FILE     VALUE 1.                   
001602                                                 
001603  01 CONVERT     PIC X(8) VALUE 'CONVERT'.       
001604                                                 
001610  PROCEDURE DIVISION.                            
001611                                                 
001620 *    EXEC SQL DELETE FROM PRODUCTS END-EXEC     
001630                                                 
001700      PERFORM OPEN-FILE                          
001800      PERFORM TRAITEMENT-FICHIER UNTIL END-OF-FILE 
001900       PERFORM COMMIT-SQL                          
002200       PERFORM CLOSE-FILE                          
002210       STOP RUN.                                   
002220                                                   
002230  OPEN-FILE.                                       
002240      OPEN INPUT NEWPRDS                           
002250      .                                            
002260  CLOSE-FILE.                                      
002270      CLOSE NEWPRDS                                
002280      .                                            
002290  TRAITEMENT-FICHIER.                              
002300      READ NEWPRDS AT END                          
002400         SET END-OF-FILE TO TRUE                   
002500      END-READ                                     
002600      PERFORM TRAITEMENT-LIGNE.                    
002610                                                   
002700  TRAITEMENT-LIGNE.                                
002800      UNSTRING NEWPRODS-RECORD                             
002810         DELIMITED BY DELIMITER-VAR                        
002820         INTO WS-PRO-ID                                    
002830              WS-DESCRIPTION                               
002840              WS-PRICE-TEXT                                
002850              WS-DEVISE                                    
002860      END-UNSTRING.                                        
002870      INSPECT WS-PRICE-TEXT CONVERTING '.' TO ','          
003000      PERFORM FORMATTAGE-DESCRIPTION                       
003010      PERFORM CONVERT-TO-USD                               
003011 *   PERFORM DISPLAY-PRIX                                 
003020      PERFORM INSERT-INTO-DB.                              
003100                                                           
003200  FORMATTAGE-DESCRIPTION.                                  
003700                                                           
003710      DISPLAY 'CHAINE AVANT FORMAT :' WS-DESCRIPTION       
003720      PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I >        
003730                           FUNCTION LENGTH(WS-DESCRIPTION) 
003740         MOVE WS-DESCRIPTION(WS-I:1) TO LETTRE-ACT          
003741                                                            
003750         IF FIRST-WORD = 'O' OR LETTRE-ACT = ' '            
003760            MOVE 'N' TO FIRST-WORD                          
003770            IF LETTRE-ACT = ' '                             
003780               MOVE 'O' TO FIRST-WORD                       
003790               MOVE LETTRE-ACT TO WS-DESC-FORM(POINT-OUT:1) 
003791          ELSE                                              
003792          MOVE FUNCTION UPPER-CASE(LETTRE-ACT) TO MAJ       
003793          MOVE MAJ TO WS-DESC-FORM(POINT-OUT:1)             
003794          END-IF                                            
003795          ELSE                                              
003796             MOVE FUNCTION LOWER-CASE(LETTRE-ACT) TO MIN    
003797             MOVE MIN TO WS-DESC-FORM(POINT-OUT:1)          
003798          END-IF                                            
003799          ADD 1 TO POINT-OUT                                
003800      END-PERFORM                                           
003801      DISPLAY "CHAINE FORMATEE : " WS-DESC-FORM             
003802      INITIALIZE WS-DESC-FORM                                   
003803      MOVE 1 TO POINT-OUT                                       
003804      .                                                         
003805                                                                
003806  CONVERT-TO-USD.                                               
003808      CALL  CONVERT  USING WS-DEVISE                            
003809                              WS-PRICE-TEXT                     
003810                              WS-PRICE-USD.                     
003820 *    EVALUATE WS-DEVISE                                        
003900 *    WHEN 'EU'                                                 
004000 *      COMPUTE WS-PRICE-USD = FUNCTION NUMVAL(WS-PRICE-TEXT) * 
004100 *    WHEN 'DO'                                                 
004200 *      COMPUTE WS-PRICE-USD = FUNCTION NUMVAL(WS-PRICE-TEXT)   
004310 *    WHEN 'YU'                                                 
004320 *      COMPUTE WS-PRICE-USD = FUNCTION NUMVAL(WS-PRICE-TEXT) * 
004330 *    WHEN OTHER                                                
004400 *       DISPLAY 'DEVISE NON REPERTORIEE '                      
004500 *    END-EVALUATE.                                             
 004600                                                      
 004610 *  DISPLAY-PRIX.                                    
 004620 *   MOVE WS-PRICE-USD TO ED-PRICE-USD               
 004630 *   DISPLAY 'PRIX FROMATE USD : ' ED-PRICE-USD      
 004640 *   .                                               
 004700  INSERT-INTO-DB.                                     
 004800      MOVE WS-PRICE-USD TO PRO-PRICE                  
 005200      EXEC SQL                                        
 005300         INSERT INTO PRODUCTS                         
 005400         VALUES (:WS-PRO-ID,                          
 005500                 :WS-DESCRIPTION,                     
 005600                 :PRO-PRICE)                          
 005700      END-EXEC                                        
 005800      PERFORM EVAL-INSERT                             
 005900      .                                               
 006100  EVAL-INSERT.                                        
 006110                                                      
 006200      EVALUATE TRUE                                   
006300      WHEN SQLCODE = ZERO                                
006400           DISPLAY 'INSERT OK'                           
006500      WHEN SQLCODE = -803                                
006600           DISPLAY 'ERREUR INSERT DOUBLON : ' WS-PRO-ID  
006700      WHEN SQLCODE > 0                                   
006800           DISPLAY 'WARNING SQL : ' SQLCODE              
006900      WHEN OTHER                                         
007000           DISPLAY 'ABEND SQL : ' SQLCODE                
007100           DISPLAY SQLSTATE                              
007110           DISPLAY SQLERRM                               
007120           DISPLAY SQLERRP                               
007130           DISPLAY SQLERRD(3)                            
007200           PERFORM ABEND-PROG                            
007300      END-EVALUATE                                       
007400      .                                                  
007500  COMMIT-SQL.                                            
007600      EXEC SQL COMMIT END-EXEC                           
007700      PERFORM EVAL-SQLCODE                               
007710      .                                               
007800  ABEND-PROG.                                         
007810      EXEC SQL ROLLBACK END-EXEC                      
007900      COMPUTE WS-ANO = WS-ANO / WS-VAR.               
007910                                                      
008000  EVAL-SQLCODE.                                       
008100      EVALUATE TRUE                                   
008200      WHEN SQLCODE = ZERO                             
008300           CONTINUE                                   
008400      WHEN SQLCODE > 0                                
008500           IF SQLCODE = +100 THEN                     
008600              DISPLAY 'FIN TABLE |'                   
008700           ELSE                                       
008800              DISPLAY 'WARNING : ' SQLCODE            
008900           END-IF                                     
009000      WHEN OTHER                                      
009100              DISPLAY 'ANOMALIE GRAVE : ' SQLCODE     
009200      END-EVALUATE.                                   