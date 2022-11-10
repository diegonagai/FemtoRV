# FemtoRV

O FemtoRV é um processador minimalista de 32-bit com arquitetura RISC-V desenvolvido por [Bruno Levy](https://github.com/BrunoLevy).

Inicialmente o FemtoRV foi projetado para rodar em uma [iCEstick](https://www.latticesemi.com/icestick), uma placa com uma FPGA de apenas 1280 elementos lógicos! Com o passar do tempo novas placas também passaram a ser suportadas, como a [iCEBreaker](https://docs.icebreaker-fpga.org/hardware/icebreaker/), [ARTY](https://digilent.com/shop/arty-a7-artix-7-fpga-development-board/), [ULX3S](https://radiona.org/ulx3s/) entre outras.

Mesmo com diferentes placas suportadas, não há um port para placas com FPGAs **Altera/Intel**, pois o projeto utiliza ferramentas open-source como o [Yosys](https://github.com/YosysHQ/yosys) e o [NextPnR](https://github.com/YosysHQ/nextpnr) que no momento suportam apenas algumas famílias de FPGAs **Lattice** e **Xilinx**.
 
 Para poder estudar o FemtoRV e a arquitetura RISC-V mesmo não possuindo nenhuma das placas suportadas resolvi fazer o port para a placa [DE10-Lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021#:~:text=Terasic%20DE10-Lite%20is%20a%20cost-effective%20Altera%20MAX%2010,logic%20elements%20%28LEs%29%20and%20on-die%20analog-to-digital%20converter%20%28ADC%29.) que já possuo.
 
 Utilizei a versão free do [Quartus](https://www.intel.com/content/www/us/en/software-kit/665990/intel-quartus-prime-lite-edition-design-software-version-18-1-for-windows.html) (**Intel Quartus Prime Lite Edition 18.1**) para síntese e o **ModelSim**, também na sua versão free já inclusa no Quartus (**Starter Edition 10.5**) para rodar as simulações.
 
 Como ponto de partida utilizei o tutorial [**From Blinker to RISC-V**](https://github.com/BrunoLevy/learn-fpga/tree/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV) do Bruno Levy.
 
 Este repositório contém o resultado do processo de portabilidade, customização e implementação do FemtoRV e está organizado da seguinte forma:
