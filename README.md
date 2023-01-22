# VSQP Data and Scripts
Here follows an explanation of the file organization of this databaset
## Data
   Here it is possible to find the raw data from the Dynamic, Static and Motor Bench tests
## Scripts
Here it is possible to find the scripts used to process the data, draw conclusion and create the plots

| Script Name                | Purpose of script |
| -------------              | ------------- |
| plots_save                 | Main folder of save plots     |
| plots_single               | Folder of saved plots not combined  |
| sw                         | Folder with some useful functions  |
| Appendix                   | Appendix of the paper  |
| data_analyser              | Script to analyse static data of Aerodynamic Surfaces (Joint analysis : e.g. All forces and Moments Simultaneously)  |
| data_analyser_pitch        | Content Cell  |
| data_analyser_single       | Script to analyse static data of Aerodynamic Surfaces (Singular specific analysis : e.g. Every moment is analysed on its own)  |
| database_generator         | Script to post process raw data  |
| mot_effectiveness_vs_skew  | Script to analyse evolution of motor effectiveness with skew  |
| plot_transition            | Script to analyse data from the transition test  |
| rmse_log_all_actuators     | Saved RMSE result of modelling of the Aerodynamic Surfaces |
| RSQP_EFF_V8                | Script to analyse doublets on motors and extract effectiveness  |
| Automatic_skew_controller  | Script with optimization problem for the automatic skew controller|
