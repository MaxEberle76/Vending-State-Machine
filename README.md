# Vending-State-Machine
This project was developed in two parts for a university lab project. The first part is a sequence detector that outputs '1' whenever it receives the sequence "10x01", where 'x' can be either '0' or '1'. It is designed so it can detect overlapped sequences as well.   

The second part builds off the finite state machine aspect of the first part to implement a vending machine. This accepts denominations of $5, $10, $20, and $50, and "dispenses" a $10 item and a $15 item once sufficient funds have been added. Any leftover change is also "dispensed", the amount of which is displayed on a seven-segment display. 
