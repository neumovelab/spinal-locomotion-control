# Unified comparison of spinal locomotion control architectures in neuromechanical simulations

This repository contains the MATLAB/Simulink simulation framework, controller implementations, and optimized parameter sets used in Ton and Song, “Unified comparison of spinal locomotion control architectures in neuromechanical simulations.”

[Video demonstration of simulated locomotion results](https://youtu.be/suMJIfZYe5k?si=GeTNjrnSL4SfAJ-T)

---

## Implemented spinal-level control models

* Song S & Geyer H (2015). A neural circuitry that emphasizes spinal feedback generates diverse behaviours of human locomotion. *J Physiol* 593, 3493–3511.
* Ogihara N & Yamazaki N (2001). Generation of human bipedal locomotion by a bio-mimetic neuro-musculo-skeletal model. *Biol Cybern*, 84(1):1–11.
* Aoi S, Ohashi T, Bamba R, et al. (2019). Neuromusculoskeletal model that walks and runs across a speed range with a few motor control parameter changes based on the muscle synergy hypothesis. *Sci Rep* 9, 369.
* Di Russo A, Stanev D, Sabnis A, et al. (2023). Investigating the roles of reflexes and central pattern generators in the control and modulation of human locomotion using a physiologically plausible neuromechanical model. *Journal of Neural Engineering*, 20(6), 066006.

---

## Optimization framework

Controller parameters are optimized using the covariance matrix adaptation evolution strategy (CMA-ES):
* Hansen, N. (2006). The CMA evolution strategy: a comparing review. Towards a new evolutionary computation: Advances in the estimation of distribution algorithms, 75-102.

This repository includes third-party MATLAB code for CMA-ES in `ext/`. The included CMA-ES files are distributed under their original license. See the source files in `ext/` for details.

Source:
https://cma-es.github.io/cmaes_sourcecode_page.html

---

## Requirements

* MATLAB (2024b or higher) / Simulink / SimScape Multibody
* Parallel Computing Toolbox, for parallel optimization running `main_optim_compLoco_2D.m`

Optional but recommended:
* A MATLAB-supported C/C++ compiler, to run Simulink in accelerator mode for faster computation
    * We recommend to run in accelerator mode. When using this mode, new MEX files will be built when changes to the .slx file are made, or when simulating different slope conditions.
    * Set desired Simulink model mode with `flag_modelMode` in main scripts:
        * `flag_modelMode = "accelerator"` for hand-tuning parameters and optimization
        * `flag_modelMode = "normal"` for general troubleshooting
        * Source: https://www.mathworks.com/help/matlab/matlab_external/install-mingw-support-package.html

---

## Description and Main Scripts

| Path | Description |
|------|-------------|
| `\params` | Parameter sets achieved in optimization for each controller. Files saved as `.mat` using the convention `param_[controller]_v[v_tgt]_sp/n[slope]`, where:<br>• `[controller]` — controller to simulate with (reflex, CPG-reflex, muscle synergy, or CPG-reflex-synergy)<br>• `[v_tgt]` — target speed scaled by 10 (e.g. `12` = 1.2 m/s)<br>• `[slope]` — `p` positive slope, `n` negative slope, slope in degrees <br>• Example: `param_reflex_v12_sp10.mat` == parameter set for the reflex controller walking at target speed 1.2 m/s at a slope of +10 degrees|
| `\ext` | External `.m` files for CMA-ES (Hansen N (2006)). |
| `\model` | Scripts for setting controller, initial condition, musculoskeletal, and environment parameters, and the Simulink model (`.slx`). |
| `\src` | `parfor_sim.m` for parallel computation optimization; `sim_nms_controllers_2D_cost.m` for running a single simulation. |
| `main_compLoco_2D.m` | Main script — runs a single simulation. |
| `main_optim_compLoco.m` | Main script — runs optimization. |

---

## Disclaimer

Simulation results may vary slightly across machines, MATLAB versions, solvers, and numerical settings. Further optimization may be necessary to reproduce or extend optimal gait behaviors under different computational environments or modified task conditions.

---

## Citation

If you use this repository in your research, please cite:
 
> Ton V, Song S. Unified comparison of spinal locomotion control architectures in neuromechanical simulations. Submitted.

Please also cite the original publication(s) for the specific control model(s) used.