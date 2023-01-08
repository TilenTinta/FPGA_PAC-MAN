# FPGA_PAC-MAN
Zaključni projekt pri predmetu Načrtovanje digitalnih integriranih vezji (Modul: B)
Ploščica:
 - DE0-Nano, Altera Cyclone IV
 - UL FE LNIV custom PCB

Projekt je celovit sistem ki združuje 12 bitni mikroprocesor, VGA driver in grafično enoto.
Mikroprocesor je možno programirati v assembly jeziku, ki ga prevedemo s pomočjo spletne strani:
 - https://lniv.fe.uni-lj.si/old/cpu.html 

Dobljeno sintakso shranimo v .mif datoteko in to naložimo na ploščico.
Na ekranu se nam prikaže igra PAC-MAN katero začnemo z klikom na tipko reset (na DE0 desna tipka pod pleksijem)
S štirimi tipkami lahko usmeramo pacmana. Igra deluje po skoraj enakih pravilih kot original.
