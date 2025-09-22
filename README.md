# 📝 Asynchronous FIFO Design and Verification
![0.1](https://img.shields.io/badge/Version-0.1-violet)
![Verilog](https://img.shields.io/badge/HDL-Verilog-blueviolet)
![SystemVerilog](https://img.shields.io/badge/HDL-SystemVerilog-blueviolet)
![UVM](https://img.shields.io/badge/Verification-UVM-green)
![VCS](https://img.shields.io/badge/Simulator-Synopsys%20VCS-red)
![Verdi](https://img.shields.io/badge/Debugging-Verdi-red)
![GitHub last commit](https://img.shields.io/github/last-commit/Karan-nevage/Asynchronous-FIFO-Design-and-Verification)
![GitHub repo size](https://img.shields.io/github/repo-size/Karan-nevage/Asynchronous-FIFO-Design-and-Verification)
![GitHub contributors](https://img.shields.io/github/contributors/Karan-nevage/Asynchronous-FIFO-Design-and-Verification)


This repository contains a comprehensive **Asynchronous FIFO** (First-In, First-Out) design and a complete **Universal Verification Methodology (UVM)** testbench for its functional verification. The project demonstrates a robust, real-world approach to digital design and verification.

## 🧰 Tech Stack & Tools



The core of this project is an asynchronous FIFO, which is a critical component in many digital systems for buffering data between different clock domains. This design uses a dual-clock approach with separate read and write clocks, making it suitable for applications that require communication between modules operating at different frequencies. The verification environment, built with **SystemVerilog** and **UVM**, follows a layered, reusable, and scalable architecture. It includes all essential UVM components like `uvm_sequencer`, `uvm_driver`, `uvm_monitor`, `uvm_agent`, `uvm_env`, and `uvm_scoreboard`, and a `uvm_test_lib` with various test scenarios to ensure a high level of functional coverage.

# 🔑 Key Features

* **Asynchronous FIFO**: Implemented in Verilog, the design handles data transfer between two independent clock domains: `wclk_i` (write clock) and `rclk_i` (read clock).
* **Configurable Parameters**: The FIFO's **`WIDTH`** (data width) and **`DEPTH`** (number of entries) are easily adjustable.
* **Pointer Synchronization**: To handle CDC, the design synchronizes read and write pointers and their toggle flags using dedicated synchronization logic.
* **Status Flags**: The FIFO provides signals for `full_o`, `empty_o`, and `error_o` to indicate its status and potential overflow or underflow conditions.
* **Reusable Sequences**: The project includes `fifo_seq.sv` with various sequences to target specific test scenarios, such as `wr_rd_seq` for a single write/read, `fifo_n_wr_rd_seq` for concurrent transactions, and sequences for full, empty, overflow, and underflow conditions.
* **Transaction-Level Scoreboard (`fifo_sbd.sv`)**: A scoreboard is used to verify data integrity by comparing the data written into the FIFO with the data read from it.
* **Functional Coverage (`fifo_cov.sv`)**: A `covergroup` is defined to measure functional coverage, ensuring that critical scenarios and signal combinations are exercised during simulation.

---

# 📐 Testbench Architecture & File Structure
The verification environment follows a modular, hierarchical structure as shown in the UVM testbench topology.

![FIFO TB ARCHITECTURE](https://github.com/Karan-nevage/Asynchronous-FIFO-Design-and-Verification/blob/main/images/FIFO%20TB%20ARCHITECTURE.png?raw=true)

| Folder | Contents |
| :--- | :--- |
| **common** | Contains common files used by both the DUT and the testbench. These include configuration definitions (`fifo_config.sv`), transaction class (`fifo_tx.sv`), and both read (`fifo_rintf.sv`) and write (`fifo_wintf.sv`) interfaces. |
| **master** | Contains the components for the read and write agents, including drivers (`fifo_rdrv.sv`, `fifo_wdrv.sv`), sequencers (`fifo_rsqr.sv`, `fifo_wsqr.sv`), and sequences that generate transactions (`fifo_seq.sv`). |
| **slave** | Contains the asynchronous FIFO RTL design (DUT) (`async_fifo.v`). |
| **top** | Contains the top-level testbench components, including the monitor (`fifo_mon.sv`), scoreboard (`fifo_sbd.sv`), coverage collector (`fifo_cov.sv`), environment (`fifo_env.sv`), and test library (`fifo_test_lib.sv`). |
| **sim** | Contains the simulations releated file, including the list of all components (`fifo_list.sv`) and run file (`run.sh`). |
| **src** | Contains the UVM packag, you can also download it fron official wrbsite. |


### Signals in DUT and Testbench

The following table details the signals used in the DUT and testbench interfaces.

| Signal Name | Direction | Description |
| :--- | :--- | :--- |
| `wclk_i` | Input | Write clock. |
| `rclk_i` | Input | Read clock. |
| `rst_i` | Input | Asynchronous reset signal. |
| `wr_en_i` | Input | Write enable signal. |
| `rd_en_i` | Input | Read enable signal. |
| `wdata_i` | Input | Data to be written into the FIFO. |
| `rdata_o` | Output | Data read from the FIFO. |
| `empty_o` | Output | Status signal indicating if the FIFO is empty. |
| `full_o` | Output | Status signal indicating if the FIFO is full. |
| `error_o` | Output | Status signal indicating an overflow or underflow error. |
| `wr_ptr` | Internal | Write pointer. |
| `rd_ptr` | Internal | Read pointer. |
| `wr_ptr_rd_clk` | Internal | Write pointer synchronized to the read clock. |
| `rd_ptr_wr_clk` | Internal | Read pointer synchronized to the write clock. |
| `wr_toggle_f` | Internal | Toggle flag for write pointer wrap-around detection. |
| `rd_toggle_f` | Internal | Toggle flag for read pointer wrap-around detection. |
| `wr_toggle_f_rd_clk` | Internal | Write toggle flag synchronized to the read clock. |
| `rd_toggle_f_wr_clk` | Internal | Read toggle flag synchronized to the write clock. |

---

### ⚙️ Running the Simulation

This project uses the **Synopsys VCS** and **Verdi** tools for compilation and simulation. The following steps and commands will guide you through the process.

<br>

| Step | Command | Description |
| :--- | :--- | :--- |
| **1. Navigate** | `cd sim` | Go to your simulation directory. |
| **2. Shell** | `tcsh` | Switch to the `tcsh` shell. |
| **3. Source** | `source /path/to/your/tool/cshrc` | Source the environment setup file for your EDA tools. |
| **4. Check Executable** | `ls -ltr run.sh` | Verify if the `run.sh` script has execute permissions. |
| **5. Add Permission** | `chmod +x run.sh` | If the script is not executable, use this command to add the necessary permissions. |
| **6. Run** | `./run.sh` | Execute the simulation script. This will compile the code and start the simulation based on the `run.sh` file. The script specifies SystemVerilog file compilation (`-sverilog`), uses the 64-bit tool (`-full64`), enables full debug access (`-debug_access+all`), and generates a database for waveform viewing (`-kdb`). It also runs the specified test and generates coverage metrics for line, condition, toggle, FSM, assertion, and branch. |

<br>

Once the simulation is complete, the following commands can be used to open the waveform viewer and coverage report.

| Tool | Command | Description |
| :--- | :--- | :--- |
| **Verdi Waveform** | `verdi -ssf fifo_waveform.fsdb &` | Opens the waveform file (`fifo_waveform.fsdb`) in Verdi. |
| **Verdi Coverage** | `verdi -cov -covdir simv.vdb &` | Opens the functional and code coverage report. |

![FIFO WAVEFORM](https://github.com/Karan-nevage/Asynchronous-FIFO-Design-and-Verification/blob/main/images/FIFO%20WAVEFORM.png?raw=true)

---
### ✒️ Author & Contribution

**Author:** Karankumar Nevage
**Email:** karanpr9423@gmail.com
**LinkedIn:** [https://www.linkedin.com/in/karankumar-nevage/](https://www.linkedin.com/in/karankumar-nevage/)

Feel free to fork this repository, submit issues, or create pull requests for enhancements. Contributions to add new test sequences or improve coverage are welcome.

---

### 📜 License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---

### 📈 Project Status

**Version:** 0.1
**Last Update:** 21 September 2025

---

