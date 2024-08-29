Architecture:
![image](https://github.com/user-attachments/assets/bcdaf2ce-9f4a-4746-a368-56ae24490b17)

To run: 
1. chmod +x run_core.sh
2. ./run_core.sh

Preview:
1. Instruction memory is initialized with a n-Fibonnaci series program.
   ![image](https://github.com/user-attachments/assets/8280292c-4731-4e52-9c6d-27db1753f62c)
2. At the beginning, it’s observed that the n=22 (17711) is computed and written into register X8.
3. p and q for the next iteration are updated as 10946 and 17711 followed by a Branch instruction. 
4. Followed by a successful penultimate branch, final sum for n=23 (28657) is computed.
5. An unconditional branch (Jump and Link instruction) is taken to reach the Halt instruction.
6. Halt stops the Program Counter in instruction fetch unit and the other state registers from updating.
