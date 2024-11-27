 IDENTIFICATION DIVISION.                
 PROGRAM-ID. PART2.                      
*****************************************
 ENVIRONMENT DIVISION.                   
 CONFIGURATION SECTION.                  
 SPECIAL-NAMES.                          
     DECIMAL-POINT IS COMMA.             
                                         
 INPUT-OUTPUT SECTION.                   
 FILE-CONTROL.                           
     SELECT VENTAS ASSIGN TO FICVAS.     
     SELECT VENTEU ASSIGN TO FICVEU.     
                                         
*****************************************
 DATA DIVISION.                          
 FILE SECTION.                           
 FD VENTAS.                              
 01 ENR-VENTAS.                          
    05 NO-COMM-VENTAS    PIC 9(3).       
    05 DATE-COMM-VENTAS.                 
       10 JOUR-COMM-VENTAS PIC X(02).    
       10 FILLER            PIC X(01).   
       10 MOIS-COMM-VENTAS  PIC X(02).   
       10 FILLER            PIC X(01).   
       10 ANNEE-COMM-VENTAS PIC X(04).   
    05 NO-EMP-VENTAS     PIC 9(2).       
    05 NO-CLIENT-VENTAS  PIC 9(4).       
    05 NO-PROD-VENTAS    PIC X(3).       
    05 PRIX-VENTAS       PIC 9(3)V99.    
    05 QUANTITE-VENTAS   PIC 99.         
    05 FILLER            PIC X(6).       
                                         
 FD VENTEU.                              
 01 ENR-VENTEU.                          
    05 NO-COMM-VENTEU    PIC 9(3).       
    05 DATE-COMM-VENTEU.
       10 JOUR-COMM-VENTEU PIC X(02).     
       10 FILLER            PIC X(01).    
       10 MOIS-COMM-VENTEU  PIC X(02).    
       10 FILLER            PIC X(01).    
       10 ANNEE-COMM-VENTEU PIC X(04).    
    05 NO-EMP-VENTEU     PIC 9(2).        
    05 NO-CLIENT-VENTEU  PIC 9(4).        
    05 NO-PROD-VENTEU    PIC X(3).        
    05 PRIX-VENTEU       PIC 9(3)V99.     
    05 QUANTITE-VENTEU   PIC 99.          
    05 FILLER            PIC X(6).        
                                          
 WORKING-STORAGE SECTION.                 
                                          
     EXEC SQL                             
        INCLUDE SQLCA                     
     END-EXEC.                            
                                          
     EXEC SQL                             
        INCLUDE ORDERS                    
     END-EXEC.                            
                                          
     EXEC SQL                             
        INCLUDE CUSTOMER                  
     END-EXEC.                            
                                          
     EXEC SQL                             
        INCLUDE ITEMS                     
     END-EXEC.                            
                                          
     EXEC SQL                             
        INCLUDE PRODUCTS                  
     END-EXEC.                            
                                          
 77 WS-FLAG-AS           PIC 9 VALUE ZERO.
 77 WS-FLAG-EU           PIC 9 VALUE ZERO.
 77 WS-ANO               PIC 99 VALUE ZERO.                 
 77 ED-SQLCODE           PIC 9(10).                         
 77 WS-MONTANT           PIC S9(8)V99 USAGE COMP-3.         
 77 WS-TOTAL-TO-UPDATE   PIC S9(8)V99 USAGE COMP-3.         
 77 WS-DISPLAY-NO-UPDATE PIC X(120) VALUE SPACE.            
 77 ED-NO-CUSTOMER       PIC X(4) VALUE SPACE.              
 77 LAST-ORDER           PIC S9(3)V USAGE COMP-3 VALUE ZERO.
 77 P2DDATE              PIC X(8) VALUE 'P2DDATE'.          
                                                            
 PROCEDURE DIVISION.                                        
                                                            
     OPEN INPUT VENTEU VENTAS                               
                                                            
     PERFORM LECT-VENTEU                                    
     PERFORM LECT-VENTAS                                    
                                                            
************************************                        
*** LECTURE SYNCHRONE                                       
************************************                        
     PERFORM UNTIL WS-FLAG-EU = 1 AND WS-FLAG-AS = 1        
        IF NO-COMM-VENTEU <= NO-COMM-VENTAS THEN            
           PERFORM PREPARE-DATA-VENTEU                      
           PERFORM INSERT-DATA-TO-BDD                       
           PERFORM LECT-VENTEU                              
        ELSE                                                
           PERFORM PREPARE-DATA-VENTAS                      
           PERFORM INSERT-DATA-TO-BDD                       
           PERFORM LECT-VENTAS                              
        END-IF                                              
      END-PERFORM                                           
                                                            
     CLOSE VENTEU VENTAS                                    
                                                            
     GOBACK.
 PREPARE-DATA-VENTEU.                              
     DISPLAY '*****************'                   
     DISPLAY 'NO-COMM-VENTEU : ' NO-COMM-VENTEU    
     MOVE NO-COMM-VENTEU TO ORDERS-O-NO            
     MOVE NO-EMP-VENTEU TO ORDERS-S-NO             
     MOVE NO-CLIENT-VENTEU TO ORDERS-C-NO          
     MOVE NO-PROD-VENTEU TO ITEMS-P-NO             
     MOVE QUANTITE-VENTEU TO ITEMS-QUANTITY        
     MOVE PRIX-VENTEU TO ITEMS-PRICE               
     PERFORM IF-PRICE-ZERO-COPY-PRICE              
                                                   
     CALL P2DDATE USING BY CONTENT DATE-COMM-VENTEU
                         BY REFERENCE ORDERS-O-DATE
     .                                             
                                                   
 PREPARE-DATA-VENTAS.                              
     DISPLAY '*****************'                   
     DISPLAY 'NO-COMM-VENTAS : ' NO-COMM-VENTAS    
     MOVE NO-COMM-VENTAS TO ORDERS-O-NO            
     MOVE NO-EMP-VENTAS TO ORDERS-S-NO             
     MOVE NO-CLIENT-VENTAS TO ORDERS-C-NO          
     MOVE NO-PROD-VENTAS TO ITEMS-P-NO             
     MOVE QUANTITE-VENTAS TO ITEMS-QUANTITY        
     MOVE PRIX-VENTAS TO ITEMS-PRICE               
     PERFORM IF-PRICE-ZERO-COPY-PRICE              
                                                   
     CALL P2DDATE USING BY CONTENT DATE-COMM-VENTEU
                        BY REFERENCE ORDERS-O-DATE 
     .                                             
     
***************************************************              
*** IF PRICE ZERO THEN COPY PRICE FROM PRODUCTS ***              
***************************************************              
 IF-PRICE-ZERO-COPY-PRICE.                                       
     IF ITEMS-PRICE EQUAL ZERO THEN                              
                                                                 
        EXEC SQL                                                 
          SELECT PRICE                                           
               INTO :PROD-PRICE                                  
          FROM API5.PRODUCTS                                     
          WHERE P_NO = :ITEMS-P-NO                               
        END-EXEC                                                 
                                                                 
        EVALUATE TRUE                                            
           WHEN SQLCODE = ZERO                                   
                DISPLAY 'PRICE FROM COPY : ' PROD-PRICE          
                MOVE PROD-PRICE TO ITEMS-PRICE                   
                                                                 
           WHEN SQLCODE > ZERO                                   
                IF SQLCODE = +100 THEN                           
                          DISPLAY PROD-PRICE ' PRICEINEXISTANT !'
                ELSE                                             
                          DISPLAY 'WARNING PRICE : ' SQLCODE     
                END-IF                                           
           WHEN OTHER                                            
                DISPLAY 'ANOMALIE GRAVE PRICE : ' SQLCODE        
                PERFORM ABEND-PROG                               
        END-EVALUATE                                             
     END-IF                                                      
     .

 INSERT-DATA-TO-BDD.                         
     IF ORDERS-O-NO NOT EQUAL LAST-ORDER THEN
        PERFORM EXEC-SQL-INSERT-INTO-ORDERS  
        PERFORM EVAL-SQL-INSERT-ORDERS       
     END-IF                                  
                                             
     PERFORM EXEC-SQL-INSERT-INTO-ITEMS      
     PERFORM EVAL-SQL-INSERT-ITEMS           
                                             
     PERFORM ADD-AMOUNT-TO-BALANCE           
                                             
     MOVE ORDERS-O-NO TO LAST-ORDER          
     .                                       
                                             
 EXEC-SQL-INSERT-INTO-ITEMS.                 
     EXEC SQL                                
         INSERT INTO API5.ITEMS              
         (O_NO, P_NO, QUANTITY, PRICE)       
         VALUES(:ORDERS-O-NO,                
                :ITEMS-P-NO,                 
                :ITEMS-QUANTITY,             
                :ITEMS-PRICE)                
     END-EXEC                                
     .
EVAL-SQL-INSERT-ITEMS.                                        
    EVALUATE TRUE                                             
        WHEN SQLCODE = ZERO                                   
             DISPLAY 'INSERT ITEMS OK ' ORDERS-O-NO           
                                                              
        WHEN SQLCODE = -803                                   
             DISPLAY 'ERREUR INSERT ITEMS : DOUBLON'          
                                                              
        WHEN SQLCODE = -530                                   
             DISPLAY 'ERREUR INSERT ITEMS : DATA NON CONFORME'
                                                              
        WHEN SQLCODE > ZERO                                   
             DISPLAY 'WARNING ITEMS : ' SQLCODE               
        WHEN OTHER                                            
             DISPLAY 'ANOMALIE GRAVE ITEMS ' SQLCODE          
             PERFORM ABEND-PROG                               
    END-EVALUATE                                              
    .                                                         
                                                              
EXEC-SQL-INSERT-INTO-ORDERS.                                  
    EXEC SQL                                                  
        INSERT INTO API5.ORDERS                               
        (O_NO, S_NO, C_NO, O_DATE)                            
        VALUES(:ORDERS-O-NO,                                  
               :ORDERS-S-NO,                                  
               :ORDERS-C-NO,                                  
               :ORDERS-O-DATE)                                
    END-EXEC                                                  
    .                                                         

 EVAL-SQL-INSERT-ORDERS.                                        
     EVALUATE TRUE                                              
         WHEN SQLCODE = ZERO                                    
              DISPLAY 'INSERT ORDERS OK ' ORDERS-O-NO           
         WHEN SQLCODE = -803                                    
              DISPLAY 'ERREUR ORDERS INSERT : DOUBLON '         
         WHEN SQLCODE = -530                                    
              DISPLAY 'ERREUR INSERT INSERT : DATA NON CONFORME'
         WHEN SQLCODE > ZERO                                    
              DISPLAY 'WARNING ORDERS : ' SQLCODE               
         WHEN OTHER                                             
              DISPLAY 'ANOMALIE GRAVE ORDERS ' SQLCODE          
              PERFORM ABEND-PROG                                
     END-EVALUATE                                               
     .                                                          
                                                                
 ADD-AMOUNT-TO-BALANCE.                                         
     MOVE ZERO TO CUS-BALANCE                                   
     MOVE ZERO TO WS-MONTANT                                    
     MOVE ZERO TO WS-TOTAL-TO-UPDATE                            
                                                                
     PERFORM GET-BALANCE-CUSTOMERS                              
     PERFORM GET-AMOUNT-ITEMS                                   
                                                                
     IF CUS-BALANCE NOT = ZERO AND WS-MONTANT NOT = ZERO        
         COMPUTE WS-TOTAL-TO-UPDATE = CUS-BALANCE               
                 + WS-MONTANT                                   
         PERFORM UPDATE-CUSTOMER-BALANCE                        
     ELSE                                                       
     MOVE ORDERS-C-NO TO ED-NO-CUSTOMER                         
      STRING                                                    
         'WS-MONTANT OU CUS-BALANCE '  DELIMITED BY SIZE        
         'VAUT ZERO DONC PAS DE MISE ' DELIMITED BY SIZE        
         'A JOUR DE LA BALANCE ' DELIMITED BY SIZE              
         'POUR LE CUSTOMER : ' DELIMITED BY SIZE                
         ED-NO-CUSTOMER DELIMITED BY SIZE                       
         INTO WS-DISPLAY-NO-UPDATE                              

      END-STRING                                                 
      DISPLAY WS-DISPLAY-NO-UPDATE                               
     END-IF                                                      
     .                                                           
                                                                 
 GET-BALANCE-CUSTOMERS.                                          
     EXEC SQL                                                    
        SELECT C.BALANCE                                         
             INTO :CUS-BALANCE                                   
        FROM API5.CUSTOMERS C                                    
        JOIN API5.ORDERS O                                       
        ON O.C_NO = C.C_NO                                       
        WHERE O.C_NO = :ORDERS-C-NO                              
        AND   O.O_NO = :ORDERS-O-NO                              
     END-EXEC                                                    
     EVALUATE TRUE                                               
        WHEN SQLCODE = ZERO                                      
            DISPLAY 'GET BALANCE OK : ' CUS-BALANCE              
        WHEN SQLCODE > ZERO                                      
             IF SQLCODE = +100 THEN                              
                DISPLAY 'GET BALANCE INEXISTANT : ' ORDERS-C-NO  
             ELSE                                                
                DISPLAY 'WARNING GET BALANCE : ' SQLCODE         
             END-IF                                              
        WHEN OTHER                                               
             DISPLAY 'ANOMALIE GRAVE FROM GET BALANCE : ' SQLCODE
             PERFORM ABEND-PROG                                  
     END-EVALUATE                                                
     .                                                           
                                                                 
 GET-AMOUNT-ITEMS.                                               
     COMPUTE WS-MONTANT = ITEMS-QUANTITY * ITEMS-PRICE           
     .                                                           
                                                                 
 UPDATE-CUSTOMER-BALANCE.                                     
     EXEC SQL                                                 
          UPDATE API5.CUSTOMERS                               
          SET BALANCE = :WS-TOTAL-TO-UPDATE                   
          WHERE C_NO  = :ORDERS-C-NO                          
     END-EXEC                                                 
     EVALUATE TRUE                                            
         WHEN SQLCODE = ZERO                                  
              DISPLAY 'UPDATE OK CUS BAL ' ORDERS-C-NO        
         WHEN SQLCODE = +100                                  
              DISPLAY 'ERREUR UPDATE CUS BAL : INEXISTANT '   
         WHEN SQLCODE > ZERO                                  
              DISPLAY 'WARNING UPDATE CUS BAL : ' SQLCODE     
         WHEN OTHER                                           
              DISPLAY 'ANOMALIE GRAVE UPDATE CUS BAL ' SQLCODE
              PERFORM ABEND-PROG                              
     END-EVALUATE                                             
     .                                                        
                                                              
 LECT-VENTEU.                                                 
     READ VENTEU AT END                                       
       MOVE 1 TO WS-FLAG-EU                                   
       MOVE 999 TO NO-COMM-VENTEU                             
       DISPLAY "FICHIER VENTEU VIDE OU FINI"                  
     END-READ.                                                
                                                              
 LECT-VENTAS.                                                 
     READ VENTAS AT END                                       
       MOVE 1 TO WS-FLAG-AS                                   
       MOVE 999 TO NO-COMM-VENTAS                             
       DISPLAY "FICHIER VENTAS VIDE OU FINI"                  
     END-READ.                                                
                                                              
 ABEND-PROG.                                                  
     MOVE SQLCODE TO ED-SQLCODE                               
     DISPLAY 'ERREUR SQL, SQLCODE = ' ED-SQLCODE              
                                                                
     EXEC SQL ROLLBACK END-EXEC                                 
     PERFORM TEST-SQLCODE                                       
     COMPUTE WS-ANO = 1 / WS-ANO.                               
                                                                
 TEST-SQLCODE.                                                  
     EVALUATE TRUE                                              
        WHEN SQLCODE = ZERO                                     
             CONTINUE                                           
        WHEN SQLCODE > ZERO                                     
             DISPLAY 'WARNING : ' SQLCODE                       
        WHEN OTHER                                              
             DISPLAY 'ERREUR GRAVE FROM TEST-SQLCODE : ' SQLCODE
             PERFORM ABEND-PROG                                 
     END-EVALUATE.                                              
